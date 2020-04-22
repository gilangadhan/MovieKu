//
//  ConverterJSON.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

func parseJSONTvAll(_ result: Data) -> [TvModel]? {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(TvData.self, from: result)
        var results: [TvModel] = []
        for tv in decodedData.results{
            if let id = tv.id, let name = tv.original_name, let date = tv.first_air_date, let backdrop = tv.backdrop_path, let overview = tv.overview, let poster = tv.poster_path, let voteAverage = tv.vote_average{
                 results.append(TvModel(id: id, name: name, date: date, backdrop: backdrop, overview: overview, poster: poster, voteAverage: voteAverage))
            }
        }
        return results
        
    } catch {
        print(error)
        return nil
    }
}


func parseJSONMovieAll(_ result: Data) -> [MovieModel]? {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(MovieData.self, from: result)
        var results: [MovieModel] = []
        for movie in decodedData.results{
            if let id = movie.id, let title = movie.original_title, let date = movie.release_date, let backdrop = movie.backdrop_path, let overview = movie.overview, let poster = movie.poster_path, let voteAverage = movie.vote_average{
                results.append(MovieModel(id: id, title: title, date: date, backdrop: backdrop, overview: overview, poster: poster, voteAverage: voteAverage))
            }
        }
        return results
        
    } catch {
        print(error)
        return nil
    }
}
