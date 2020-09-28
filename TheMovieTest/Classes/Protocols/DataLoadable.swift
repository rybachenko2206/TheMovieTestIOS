//
//  DataLoadable.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit


protocol DataLoadable {
    var isLoading: BoolCompletion? { get set }
    var errorCompletion: ErrorCompletion? { get set }
}


extension DataLoadable {
    func failureHandler(_ error: TMError) {
        DispatchQueue.main.async {
            self.isLoading?(false)
            self.errorCompletion?(error)
        }
    }
}
