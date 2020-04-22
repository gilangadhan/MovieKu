//
//  MovieFavoriteTableViewCell.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 15/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class MovieFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var movieFavoritePoster: UIImageView!
    @IBOutlet weak var movieFavoriteTitle: UILabel!
    @IBOutlet weak var movieFavoriteOverview: UILabel!
    @IBOutlet weak var movieFavoriteVoteAverage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func imageStyles() {
      movieFavoritePoster.layer.cornerRadius = 10
      movieFavoritePoster.layer.masksToBounds = true
    }
    
}
