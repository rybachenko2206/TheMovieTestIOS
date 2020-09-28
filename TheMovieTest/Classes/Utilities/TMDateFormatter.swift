//
//  TMDateFormatter.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation

class TMDateFormatter {
    static let shared = TMDateFormatter()
    
    private let dateFormatter = DateFormatter()
    
    
    enum DateFormat: String {
        case server = "yyyy.MM.dd" // 2010-10-22
    }
    
    func date(from string: String?, format: DateFormat) -> Date? {
        guard let dateStr = string else { return nil }
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateStr)
    }
    
    func string(from date: Date?, format: DateFormat) -> String? {
        guard let date = date else { return nil }
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: date)
    }
}
