//
//  TvFavoriteTableViewCell.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 15/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class TvFavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tvFavoritePoster: UIImageView!
    @IBOutlet weak var tvFavoriteTitle: UILabel!
    @IBOutlet weak var tvFavoriteOverview: UILabel!
    @IBOutlet weak var tvFavoriteDate: UILabel!
    @IBOutlet weak var tvFavoriteVoteAverage: UILabel!
    
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
        tvFavoritePoster.layer.cornerRadius = 10
        tvFavoritePoster.layer.masksToBounds = true
    }
}
