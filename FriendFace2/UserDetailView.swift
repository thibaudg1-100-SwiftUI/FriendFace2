//
//  UserDetailView.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

// to make String conform to Identifiable protocol and to be able to use it in .sheet modifier:
extension String: Identifiable {
    
    public var id: String {
        self
    }
}

struct UserDetailView: View {
    
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<CachedUser>
    
    // the user to show details of
    let user: CachedUser
    // users that are his friends:
    var friends: [CachedUser] {
        // creating a dictionnary of users out of the array of users:
        var dict = [String: CachedUser]()
        for u in users {
            dict["\(u.idUnwrapped)"] = u
        }
        // filtering friends among users
        return user.friendsArray.map { friend in
            if let us = dict[friend.idUnwrapped] {
                return us
            } else {
                fatalError("Missing friend \(friend.nameUnwrapped) in Users DB")
            }
        }
    }
    // list of users that has a tag in common with this user:
    var usersForTag: [String: [CachedUser]] {
        var usersForTag = [String: [CachedUser]]()
        
        for t in user.tagsUnwrapped {
            usersForTag[t] = [] // need to initialize the array of Users here, otherwise the .append func below will fail
            for u in users {
                if u.tagsUnwrapped.contains(t) {
                    usersForTag[t]?.append(u)
                }
            }
        }
        
        return usersForTag
    }
    // layout used for the Friends Grid View:
    let layout = [ GridItem(.adaptive(minimum: 150)) ]
    // contains the Friend to show details about:
    @State private var selectedUser: CachedUser?
    @State private var selectedTag: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image("userFace")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(2)
                    .overlay(
                        Circle()
                            .strokeBorder(.black.opacity(0.1))
                    )
                    .shadow(radius: 3)
                    .padding(4)
                    .frame(width: 100)
                
                VStack(alignment: .leading) {
                    Text(user.nameUnwrapped)
                        .font(.title.bold())
                    
                    Text(user.emailUnwrapped)
                        .font(.headline)
                    
                    HStack {
                        Text("\(user.age) ans")
                            .font(.title3)
                        
                        Text("working at: \(user.companyUnwrapped)")
                            .foregroundColor(.secondary)
                    }
                    
                    Text(user.addressUnwrapped)
                        .font(.caption2)
                }
            }

            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(user.tagsUnwrapped, id: \.self) { tag in
                        Button {
                            selectedTag = tag
                        } label: {
                            Text("#\(tag)")
                                .foregroundColor(Color("tag"))
                                .bold()
                                .padding(3)
                                .background(Color.mint)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.leading, 2)
                        }
                    }
                }
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("About me")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(user.aboutUnwrapped)
                    
                    Text("My friends")
                        .font(.headline)
                        .padding(.top)
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: layout) {
                    ForEach(friends, id: \.id) { friend in
                        FriendGridView(user: friend)
                            .onTapGesture {
                                selectedUser = friend
                            }
                    }
                }
                .padding(.horizontal)
            }

        }
        .navigationTitle(user.isActive ? "Online" : "Offline")
        .navigationBarTitleDisplayMode(.inline)
        // this .sheet init is the proper way to show a sheet whose content depends on a choice made in a button:
        .sheet(item: $selectedUser) { user in
            UserDetailQuickView(user: user)
                .onTapGesture {
                    selectedUser = nil // dismiss the sheet view by pressing on it
                }
        }
        .sheet(item: $selectedTag) { tag in
            TagDetailsView(tag: tag, users: usersForTag[tag] ?? [])
                .onTapGesture {
                    selectedTag = nil // dismiss the sheet view by pressing on it
                }
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        Group {
            NavigationView {
                UserDetailView(user: Self.sampleUsers.randomElement()!)
            }
            .preferredColorScheme(.light)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            
            NavigationView {
                UserDetailView(user: Self.sampleUsers[0])
            }
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    
    static var sampleUsers: [CachedUser] {
        guard let url = Bundle.main.url(forResource: "friendface.json", withExtension: nil) else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let users = try? decoder.decode([User].self, from: data) else {
            print("Failed to decode local Bundle file")
            return []
        }
        
        var cachedUsers = [CachedUser]()

        for u in users {
            // preparing tags Swift model for tags CoreData model:
            let tags = u.tags.joined(separator: ",")
            
            let friendsMutable = NSMutableSet() // a NS Set that can be updated
            for f in u.friends {
                let friend = CachedFriend(context: Self.dataController.container.viewContext)
                friend.id = f.id
                friend.name = f.name
                friendsMutable.add(friend)
            }
            let friends = friendsMutable as NSSet
            
            let user = CachedUser(context: Self.dataController.container.viewContext)
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
            
            cachedUsers.append(user)
        }
        
        return cachedUsers
    }
}
