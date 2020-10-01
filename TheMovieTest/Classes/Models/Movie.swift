//
//  Movie.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


class Movie: Decodable {
    let id: Int64
    let posterPath: String?
    let backdropPath: String?
    let title: String?
    let overview: String?
    let releaseDate: Date?
    let popularity: Double?
    let voteAverage: Double?
    
    var videos: [MovieVideo]?
    
    static let imagesUrl = "https://image.tmdb.org/t/p/w500"
    
    var backdropUrl: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: Movie.imagesUrl)?.appendingPathComponent(path)
    }
    
    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: Movie.imagesUrl)?.appendingPathComponent(path)
    }
}


struct GetMoviesResponse: Decodable {
    let page: Int
    let totalPages: Int
    let results: [Movie]
}

