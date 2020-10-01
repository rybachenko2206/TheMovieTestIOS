//
//  CDFavoriteMovie+CoreDataProperties.swift
//  
//
//  Created by Roman Rybachenko on 30.09.2020.
//
//

import Foundation
import CoreData


extension CDFavoriteMovie {
    
    static let entityName = "CDFavoriteMovie"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFavoriteMovie> {
        return NSFetchRequest<CDFavoriteMovie>(entityName: CDFavoriteMovie.entityName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var popularity: Double
    @NSManaged public var voteAverage: Double
    @NSManaged public var videos: NSSet?

}

// MARK: Generated accessors for videos
extension CDFavoriteMovie {

    @objc(addVideosObject:)
    @NSManaged public func addToVideos(_ value: CDMovieVideo)

    @objc(removeVideosObject:)
    @NSManaged public func removeFromVideos(_ value: CDMovieVideo)

    @objc(addVideos:)
    @NSManaged public func addToVideos(_ values: NSSet)

    @objc(removeVideos:)
    @NSManaged public func removeFromVideos(_ values: NSSet)

}

extension CDFavoriteMovie {
    
    static func favoriteMovie(with movieId: Int64, in context: NSManagedObjectContext) -> CDFavoriteMovie? {
        let fetchRequest = NSFetchRequest<CDFavoriteMovie>(entityName: CDFavoriteMovie.entityName)
        let predicate = NSPredicate(format: "id = %d",  movieId)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    static func create(with movieId: Int64, in context: NSManagedObjectContext) -> CDFavoriteMovie {
        guard let entityDescr = NSEntityDescription.entity(forEntityName: CDFavoriteMovie.entityName, in: context) else {
            fatalError("create CDFavoriteMovie error received")
        }
        
        if let existingMovie = CDFavoriteMovie.favoriteMovie(with: movieId, in: context) {
            return existingMovie
        }
        
        let movie = CDFavoriteMovie(entity: entityDescr, insertInto: context)
        movie.id = movieId
        return movie
    }
    
    func update(with movie: Movie, in context: NSManagedObjectContext) {
        guard self.id == Int64(movie.id) else { return }
        
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        title = movie.title
        overview = movie.overview
        releaseDate = movie.releaseDate
        
        if let popularityValue = movie.popularity {
            popularity = popularityValue
        }
        if let vote = movie.voteAverage {
            voteAverage = vote
        }
        
        movie.videos?.forEach({
            if CDMovieVideo.video(with: $0.key, in: context) == nil {
                let newVideo = CDMovieVideo.create(with: $0, in: context)
                self.addToVideos(newVideo)
            }
        })
    }
}
