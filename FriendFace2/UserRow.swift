//
//  UserRow.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

struct UserRow: View {
    
    let user: CachedUser
    
    var status: String {
        user.isActive ? "smallcircle.filled.circle.fill" : "smallcircle.filled.circle"
    }
    
    var body: some View {
        HStack {
            Text(user.nameUnwrapped)
            Spacer()
            Image(systemName: status)
                .foregroundColor(user.isActive ? .green : .gray)
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(DynamicTypeSize.allCases, id: \.self) { item in
            UserRow(user: Self.sampleUsers[0])
                .previewLayout(.sizeThatFits)
                .environment(\.dynamicTypeSize, item)
                .previewDisplayName("\(item)")
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
    
    static var dataController = DataController()
}
