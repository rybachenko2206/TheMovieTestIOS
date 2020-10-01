//
//  MovieCell.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var isFavorite: Bool = false {
        didSet {
            favoriteButton.isSelected = isFavorite
        }
    }
    
    var favoriteTapCompletion: Completion?
    
    
    static var height: CGFloat { return 162 }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.cornerRadius = 6.0
    }

    
    @IBAction private func favoriteButtonTapped(_ sender: Any) {
        favoriteTapCompletion?()
    }
}
