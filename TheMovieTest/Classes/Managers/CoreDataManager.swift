//
//  CoreDataManager.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 30.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TheMovieTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    
    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
