//
//  CDMovieVideo+CoreDataProperties.swift
//  
//
//  Created by Roman Rybachenko on 30.09.2020.
//
//

import Foundation
import CoreData


extension CDMovieVideo {
    static let entityName = "CDMovieVideo"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovieVideo> {
        return NSFetchRequest<CDMovieVideo>(entityName: CDMovieVideo.entityName)
    }

    @NSManaged public var key: String
    @NSManaged public var name: String?
    @NSManaged public var site: String?
    @NSManaged public var size: Int64
    @NSManaged public var type: String?
    @NSManaged public var movie: CDFavoriteMovie?

}


extension CDMovieVideo {
    
    static func video(with key: String, in context: NSManagedObjectContext) -> CDMovieVideo? {
        let fetchRequest = NSFetchRequest<CDMovieVideo>(entityName: CDMovieVideo.entityName)
        let predicate = NSPredicate(format: "key = %@",  key)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    static func create(with movieVideo: MovieVideo, in context: NSManagedObjectContext) -> CDMovieVideo {
        guard let entityDescr = NSEntityDescription.entity(forEntityName: CDMovieVideo.entityName, in: context) else {
            fatalError("create CDMovieVideo error received")
        }
        let cdVideo = CDMovieVideo(entity: entityDescr, insertInto: context)
        cdVideo.key = movieVideo.key
        cdVideo.name = movieVideo.name
        cdVideo.site = movieVideo.site
        cdVideo.type = movieVideo.type
        if let size = movieVideo.size {
            cdVideo.size = Int64(size)
        }
        
        return cdVideo
    }
    
}


