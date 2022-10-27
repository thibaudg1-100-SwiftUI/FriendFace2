//
//  FriendFace2App.swift
//  FriendFace2
//
//  Created by RqwerKnot on 16/03/2022.
//

import SwiftUI

@main
struct FriendFace2App: App {
    
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
