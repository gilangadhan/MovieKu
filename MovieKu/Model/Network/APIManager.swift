//
//  APIManager.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdateResult(_ apiManager: APIManager, result: Data)
    func didFailWithError(error: Error)
}

struct APIManager {
    let apiKey = "b8e51a152ed387c46ba2d4c8ced7345d"
    let baseURL = "https://api.themoviedb.org/3/"
    
    var delegate: APIManagerDelegate?
    
    func fetchTvToday() {
        let urlString = "\(baseURL)tv/on_the_air?api_key=\(apiKey)&language=en-US&page=1"
        performRequest(with: urlString)
    }
    
    func fetchSearchTv(query: String){
        let urlString = "\(baseURL)search/tv?api_key=\(apiKey)&language=en-US&page=1&query=\(query)&include_adult=false"
        performRequest(with: urlString)
    }
    
    func fetchMovieToday() {
        let urlString = "\(baseURL)movie/now_playing?api_key=\(apiKey)&language=en-US&page=1"
        performRequest(with: urlString)
    }
    //https://api.themoviedb.org/3/search/movie?api_key=b8e51a152ed387c46ba2d4c8ced7345d&language=en-US&query=naruto&page=1&include_adult=false

    
    func fetchSearchMovie(query: String){
        let urlString = "\(baseURL)search/movie?api_key=\(apiKey)&language=en-US&page=1&query=\(query)&include_adult=false"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    self.delegate?.didUpdateResult(self, result: safeData)
                }
            }
            task.resume()
        }
    }
}



