//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace2
//
//  Created by RqwerKnot on 16/03/2022.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var users: NSSet?
    
    public var idUnwrapped: String {
        self.id ?? "Unidentified friend"
    }
    
    public var nameUnwrapped: String {
        self.name ?? "Unknown name"
    }
    
    public var usersArray: [CachedUser] {
        let users = self.users as? Set<CachedUser> ?? []
        
        return users.sorted {
            $0.nameUnwrapped < $1.nameUnwrapped
        }
    }

}

// MARK: Generated accessors for users
extension CachedFriend {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: CachedUser)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: CachedUser)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension CachedFriend : Identifiable {

}
