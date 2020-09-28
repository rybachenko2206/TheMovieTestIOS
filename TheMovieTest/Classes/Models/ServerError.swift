//
//  ServerError.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation

struct ServerError: Decodable {
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "status_code"
        case message = "status_message"
    }
}
