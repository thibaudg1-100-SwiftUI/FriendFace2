//
//  User.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import Foundation

struct User: Codable, Identifiable {
    // properties representing the JSON content:
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [Tag]
    let friends: [Friend]
    
    // if in the future, a 'Tag' is no more a simple String, but a more evolved type (Struct, Class, enum, ...), you can chnage below in one place and will update all the code:
    typealias Tag = String
    
    // nested 'Friend' struct for use in 'User' struct (might need to un-nest it in the future depending on actual use):
    struct Friend: Codable {
        let id: String
        let name: String
    }
    
}

extension User {
    static let defaultUser = User(id: "50a48fa3-2c0f-4397-ac50-64da464f9954", isActive: true, name: "Alford Rodriguez", age: 30, company: "Imkan", email: "alfordrodriguez@imkan.com", address: "907 Nelson Street, Cotopaxi, South Dakota, 5913", about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.", registered: .now, tags: ["cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim", "tempor"], friends: [Friend(id: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0", name: "Hawkins Patel")])
    
    static let hawkins = User(id: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0", isActive: true, name: "Hawkins Patel", age: 30, company: "Imkan", email: "alfordrodriguez@imkan.com", address: "907 Nelson Street, Cotopaxi, South Dakota, 5913", about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.", registered: .now, tags: ["cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim", "tempor"], friends: [Friend(id: "50a48fa3-2c0f-4397-ac50-64da464f9954", name: "Alford Rodriguez")])
    
    static var users = [defaultUser, hawkins]
}
