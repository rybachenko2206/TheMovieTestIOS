//
//  MovieCell.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    
    static var height: CGFloat { return 154 }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 6.0
    }

    
}
