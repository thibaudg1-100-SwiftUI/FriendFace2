//
//  ContentView.swift
//  FriendFace2
//
//  Created by RqwerKnot on 16/03/2022.
//

import SwiftUI

enum ActiveStatus: String {
    case all = "registered"
    case online
    case offline
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: SortOrder.forward)]) var users: FetchedResults<CachedUser>
    
    @State private var activeStatus = ActiveStatus.all
    
    var body: some View {
        NavigationView {
            VStack {
                List(users) { user in
                    
                    NavigationLink {
                        UserDetailView(user: user)
                    } label: {
                        UserRow(user: user)
                    }
                }
                .onChange(of: activeStatus, perform: { newValue in
                    switch newValue {
                    case .all:
                        users.nsPredicate = nil
                    case .online:
                        // We must aply special treatment for Boolean in CoreData when using NSPredicate:
                        //                        users.nsPredicate = NSPredicate(format: "isActive == 1")
                        // alternatively:
                        //                        users.nsPredicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
                        // alternatively:
                        //                        users.nsPredicate = NSPredicate(format: "isActive == %@", NSNumber(true))
                        // alternatively:
                        //                        users.nsPredicate = NSPredicate(format: "isActive == %d", true)
                        // alternatively:
                        users.nsPredicate = NSPredicate(format: "isActive = %d", true)
                    case .offline:
                        users.nsPredicate = NSPredicate(format: "isActive == 0")
                    }
                })
                
                Text("\(users.count) \(activeStatus.rawValue) users")
            }
            .navigationTitle("FriendFace")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        switch activeStatus {
                        case .all:
                            activeStatus = .online
                        case .online:
                            activeStatus = .offline
                        case .offline:
                            activeStatus = .all
                        }
                    } label: {
                        Image(systemName: "dot.circle.and.hand.point.up.left.fill")
                            .foregroundColor(activeStatus == .all ? .green : .white)
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        // 1: define a URL object from a String representing the URI:
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError()
        }
        
        // 2: download data using URLSession shared singleton session object:
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("Couldn't download data")
            return
        }
        
        // 3: Decode JSON:
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let decodedResponse = try? decoder.decode([User].self, from: data) else {
            print("Failed to decode JSON")
            return
        }
        
        // Quick checking what's inside the decodedResponse:
        guard !decodedResponse.isEmpty else {
            print("decodedResponse is empty")
            return
        }
        print("Data decoded, first element's name: \(decodedResponse[0].name)")
        
        // 4: Creating and saving CoreData objects from decodedResponse using the Main Actor to ensure that this process doesn't happen in the middle of SwiftUI updating the View:
        await MainActor.run {
            print("entering main actor for CoreData task")
            for u in decodedResponse {
                // preparing tags Swift model for tags CoreData model:
                let tags = u.tags.joined(separator: ",")
                
                let friendsMutable = NSMutableSet() // a NS Set that can be updated
                for f in u.friends {
                    let friend = CachedFriend(context: moc)
                    friend.id = f.id
                    friend.name = f.name
                    friendsMutable.add(friend)
                }
                let friends = friendsMutable as NSSet
                
                let user = CachedUser(context: moc)
                user.id = u.id
                user.isActive = u.isActive
                user.name = u.name
                user.age = Int16(u.age)
                user.company = u.company
                user.email = u.email
                user.address = u.address
                user.about = u.about
                user.registered = u.registered
                user.tags = tags
                user.friends = friends
                
                // No need to save moc inside the for-in loop
                // Each for-in loop iteration has added a CachedUser and CachedFriend to the live context
            }
            
            // Conditionnaly saving the changes from the live context to the persistent store:
            if moc.hasChanges {
                print("moc has changes")
                do {
                    try moc.save()
                    print("moc saved")
                }
                catch {
                    print("moc save failed...")
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13")
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
    
    static var dataController = DataController()
}
