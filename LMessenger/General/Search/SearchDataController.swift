//
//  SearchDataController.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import CoreData

class SearchDataController: ObservableObject {
    
    let persistantConainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantConainer.loadPersistentStores { description, error in
            if let error {
                print("Core data failed: \(error.localizedDescription)")
            }
        }
    }
}
