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
    
    var documentsDirectory:URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    // MARK: - Public funcs
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
    
    
    func getAllFavoriteMovies() -> [CDFavoriteMovie] {
        let fetchRequest = NSFetchRequest<CDFavoriteMovie>(entityName: CDFavoriteMovie.entityName)
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
}
