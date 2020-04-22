//
//  MovieData.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 14/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct MovieData: Codable {
    let results : [MovieItem]
}

struct MovieItem: Codable {
    let id: Int?
    let original_title: String?
    let release_date: String?
    let backdrop_path: String?
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
}
