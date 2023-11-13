//
//  CoreDataManager.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    private init(){
        container = NSPersistentContainer(name: "TodoWithCoreData")
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("\(error)")
            }
        }
    }

}
