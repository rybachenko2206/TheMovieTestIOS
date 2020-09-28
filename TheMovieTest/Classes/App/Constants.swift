//
//  Constants.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


typealias Completion = () -> Void
typealias BoolCompletion = (Bool) -> Void
typealias ErrorCompletion = (TMError) -> Void


struct Constants {
    static let tmdbApiKey = "20462b55b3fe3db7c6666348ac502323"
}


struct Keys {
    static let kPage = "page"
    static let kApiKey = "api_key"
}
