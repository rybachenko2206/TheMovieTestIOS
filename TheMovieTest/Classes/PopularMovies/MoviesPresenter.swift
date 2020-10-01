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
    
    private let network = NetworkManager()
    
    let title = "Popular movies"
    
    var allPagesLoaded: Bool {
        return currentPage >= numberOfPages
    }
    
    private var currentPage: Int = 0
    private var numberOfPages: Int = 1
    
    private var movies: [Movie] = []
    
    private var favoriteMovies: [CDFavoriteMovie]
    
    
    // MARK: - init
    init() {
        favoriteMovies = CoreDataManager.shared.getAllFavoriteMovies()
    }
    
    
    // MARK: - Public funcs
    func numberOfRows(in section: Int) -> Int {
        return movies.count
    }
    
    func movie(for indexPath: IndexPath) -> Movie? {
        return movies[safe: indexPath.row]
    }
    
    func isMovieFavorite(_ movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    func addToFavorites(_ movie: Movie) {
        let context = CoreDataManager.shared.mainContext
        let cdMovie = CDFavoriteMovie.create(with: movie.id, in: context)
        cdMovie.update(with: movie, in: context)
        CoreDataManager.shared.saveContext()
        favoriteMovies = CoreDataManager.shared.getAllFavoriteMovies()
    }
    
    func removeFromFavorites(_ movie: Movie) {
        let context = CoreDataManager.shared.mainContext
        guard let cdMovie = CDFavoriteMovie.favoriteMovie(with: movie.id, in: context) else { return }
        context.delete(cdMovie)
        CoreDataManager.shared.saveContext()
        favoriteMovies = CoreDataManager.shared.getAllFavoriteMovies()
    }
    
    
    func getMovies(completion: @escaping Completion) {
        if allPagesLoaded {
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
    
    func getVideos(for movieId: Int64, completion: @escaping Completion) {
        isLoading?(true)
        network
            .getVideos(for: movieId,
                       completion: { [weak self] result in
                        self?.isLoading?(false)
                        
                        switch result {
                        case .failure(let error):
                            self?.errorCompletion?(error)
                            
                        case .success(let response):
                            let movie = self?.movies.first(where: { $0.id == response.id })
                            movie?.videos = response.results
                            self?.saveVideosIfNeeded(videos: response.results, movieId: movieId)
                            completion()
                        }
            })
    }
    
    
    // MARK: - Private funcs
    private func saveVideosIfNeeded(videos: [MovieVideo], movieId: Int64) {
        guard let favoriteMovie = favoriteMovies.first(where: { $0.id == movieId }) else { return }
        
        let cdMovieVideos: NSMutableSet = []
        
        let context = CoreDataManager.shared.mainContext
        for video in videos {
            let cdVideo = CDMovieVideo.create(with: video, in: context)
            cdMovieVideos.add(cdVideo)
        }
        favoriteMovie.addToVideos(cdMovieVideos)
        CoreDataManager.shared.saveContext()
    }
    
}
