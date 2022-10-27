//
//  DataController.swift
//  FriendFace2
//
//  Created by RqwerKnot on 16/03/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendFace2")
    
    init() {
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("DataController failed to load data from persistent Stores: \(error.localizedDescription)")
                return
            }
            print("NSPersitentStoreDescription: \(storeDescription)")
            
            // Adding a merge policy for constrained Entity's attributes:
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
