//
//  CachedUser+CoreDataProperties.swift
//  FriendFace2
//
//  Created by RqwerKnot on 16/03/2022.
//
//

import Foundation
import CoreData


extension CachedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
        return NSFetchRequest<CachedUser>(entityName: "CachedUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?
    
    public var idUnwrapped: String {
        self.id ?? "Unidentified User"
    }
    
    public var nameUnwrapped: String {
        self.name ?? "Unknown name"
    }
    
    public var companyUnwrapped: String {
        self.company ?? "Unknown company"
    }
    
    public var emailUnwrapped: String {
        self.email ?? "Unknown email address"
    }
    
    public var addressUnwrapped: String {
        self.address ?? "Unknown postal address"
    }
    
    public var aboutUnwrapped: String {
        self.about ?? "It's pretty quiet here..."
    }
    
    public var registeredUnwrapped: Date {
        self.registered ?? Date.distantPast // no idea what it means...
    }
    
    public var tagsUnwrapped: [String] {
        self.tags?.components(separatedBy: ",") ?? []
    }
    
    public var friendsArray: [CachedFriend] {
        let friends = self.friends as? Set<CachedFriend> ?? []
        
        return friends.sorted {
            $0.nameUnwrapped < $1.nameUnwrapped
        }
    }

}

// MARK: Generated accessors for friends
extension CachedUser {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: CachedFriend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: CachedFriend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension CachedUser : Identifiable {

}
