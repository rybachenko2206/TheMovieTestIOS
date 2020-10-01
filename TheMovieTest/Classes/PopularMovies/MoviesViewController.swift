//
//  MoviesViewController.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesViewController: UIViewController, Storyboardable {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    static var storyboardName: Storyboard { return .main }
    
    private let presenter = MoviesPresenter()
    
    
    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupDataLoadable()
        
        getMovies()
    }


    // MARK: - Private funcs
    
    private func setupView() {
        title = presenter.title
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let emptyFooter = UIView(frame: CGRect.zero)
        emptyFooter.backgroundColor = .clear
        tableView.tableFooterView = emptyFooter
        
        tableView.registerCell(MovieCell.self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = MovieCell.height
    }
    
    private func setupDataLoadable() {
        presenter.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.view.isUserInteractionEnabled = false
                    self?.activity.startAnimating()
                } else {
                    self?.view.isUserInteractionEnabled = true
                    self?.activity.stopAnimating()
                }
            }
        }
        
        presenter.errorCompletion = { [weak self] error in
            DispatchQueue.main.async {
                AlertManager.simpleAlert(title: "Error", message: error.localizedDescription, controller: self)
            }
        }
    }
    
    private func getMovies() {
        presenter.getMovies(completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    private func playTrailer(for movie: Movie) {
        var videoUrl: URL?
        
        let showVideoCompletion = { [weak self] in
            guard let url = videoUrl else {
                AlertManager
                    .simpleAlert(title: "Video is not found",
                                 message: "It looks like video trailer is not exist",
                                 controller: self)
                return
            }
            
            let webViewVC = WebViewController.instantiate()
            webViewVC.url = url
            
            self?.present(webViewVC, animated: true, completion: nil)
        }
        
        if let videos = movie.videos {
            videoUrl = videos.randomElement()?.youtubeVideoUrl
            showVideoCompletion()
        } else {
            presenter.getVideos(for: movie.id, completion: {
                videoUrl = movie.videos?.randomElement()?.youtubeVideoUrl
                showVideoCompletion()
            })
        }
    }
    
    private func favoriteButtonTapped(at indexPath: IndexPath) {
        guard let movie = presenter.movie(for: indexPath) else { return }
        if presenter.isMovieFavorite(movie) {
            presenter.removeFromFavorites(movie)
        } else {
            presenter.addToFavorites(movie)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = presenter.movie(for: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieCell.self)
        cell.posterImageView.sd_setImage(with: movie.backdropUrl, placeholderImage: UIImage(named: "placeholder"))
        cell.movieNameLabel.text = movie.title
        cell.isFavorite = presenter.isMovieFavorite(movie)
        cell.favoriteTapCompletion = { [weak self] in
            self?.favoriteButtonTapped(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let movie = presenter.movie(for: indexPath) else { return }
        playTrailer(for: movie)
//        playTrailer(at: URL(string: "https://www.youtube.com/watch?v=iLl9PANQov8"))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !presenter.allPagesLoaded &&
            indexPath.row >= presenter.numberOfRows(in: indexPath.section) - 2
        {
            getMovies()
        }
    }
}
