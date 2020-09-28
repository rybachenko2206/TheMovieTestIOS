//
//  ViewController.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let network = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.getPopularMovies(completion: { [weak self] result in
            switch result {
            case .success(let response):
                pl("get movies respose: \n\(response)")
            case .failure(let error):
                pl("get movies error: \n\(error.localizedDescription)")
            }
        })
    }


}

