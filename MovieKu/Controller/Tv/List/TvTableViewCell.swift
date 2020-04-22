//
//  TvTableViewCell.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class TvTableViewCell: UITableViewCell {

    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvOverview: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvPoster: UIImageView!
    @IBOutlet weak var tvVoteAverage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         self.imageStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func imageStyles() {
      tvPoster.layer.cornerRadius = 10
      tvPoster.layer.masksToBounds = true
    }

}
