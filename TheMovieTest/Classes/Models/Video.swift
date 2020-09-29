//
//  Video.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation

class MovieVideo: Decodable {
    let id: String
    let key: String
    let name: String?
    let site: String?
    let size: Int?
    let type: String
    
    static let youtubeVideoUrl = "https://www.youtube.com/watch?v="
    
    var youtubeVideoUrl: URL? {
        guard site?.lowercased() == "youtube" else { return nil }
        let urlStr = MovieVideo.youtubeVideoUrl + key
        return URL(string: urlStr)
    }
}


struct GetVideosResult: Decodable {
    let id: Int
    let results: [MovieVideo]
}
