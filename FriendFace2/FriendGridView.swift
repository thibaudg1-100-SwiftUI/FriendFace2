//
//  FriendGridView.swift
//  FriendFace
//
//  Created by RqwerKnot on 14/03/2022.
//

import SwiftUI

struct FriendGridView: View {
    
    let user: CachedUser
    
    var body: some View {
        VStack {
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
//                .padding(4)
                .padding()
            
            VStack {
                Text(user.nameUnwrapped)
                    .font(.title3)
                    .lineLimit(1)
                
                Text(user.companyUnwrapped)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundColor(Color("tag"))
            .frame(maxWidth: .infinity)
            .background(Color.mint)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke()
        }
    }
}

struct FriendGridView_Previews: PreviewProvider {
    static var previews: some View {
        FriendGridView(user: Self.sampleUsers.randomElement()!)
            .previewLayout(.sizeThatFits)
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
    
    static var dataController = DataController()
}
