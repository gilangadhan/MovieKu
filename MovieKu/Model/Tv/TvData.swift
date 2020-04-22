//
//  MovieData.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct TvData: Codable {
    let results : [TvItem]
}

struct TvItem: Codable {
    let id: Int?
    let original_name: String?
    let first_air_date: String?
    let backdrop_path: String?
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
}

