//
//  SearchDataController.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import CoreData

protocol DataControllable {
    var persistantConainer: NSPersistentContainer { get set }
}

class SearchDataController: DataControllable {
    
    var persistantConainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantConainer.loadPersistentStores { description, error in
            if let error {
                print("Core data failed: \(error.localizedDescription)")
            }
        }
    }
}
