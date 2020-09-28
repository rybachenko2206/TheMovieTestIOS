//
//  MoviesPresenter.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


class MoviesPresenter: DataLoadable {
    
    // MARK: - Properties
    var isLoading: BoolCompletion?
    var errorCompletion: ErrorCompletion?
    
    let network = NetworkManager()
    
    let title = "Popular movies"
    
    private var currentPage: Int = 0
    private var numberOfPages: Int = 1
    
    private var movies: [Movie] = []
    
    // MARK: - Public funcs
    func numberOfRows(in section: Int) -> Int {
        return movies.count
    }
    
    func movie(for indexPath: IndexPath) -> Movie? {
        return movies[safe: indexPath.row]
    }
    
    
    func getMovies(completion: @escaping Completion) {
        if currentPage >= numberOfPages {
            return
        }
        currentPage += 1
        
        isLoading?(true)
        
        network.getPopularMovies(page: currentPage, completion: { [weak self] result in
            self?.isLoading?(false)
            
            switch result {
            case .failure(let error):
                self?.errorCompletion?(error)
                
            case .success(let response):
                self?.movies.append(contentsOf: response.results)
                self?.currentPage = response.page
                self?.numberOfPages = response.totalPages
                completion()
            }
        })
    }
    
}
