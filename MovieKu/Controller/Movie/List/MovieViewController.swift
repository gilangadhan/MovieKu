//
//  FirstViewController.swift
//  MovieKu
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    var apiManager = APIManager()
    var movieList: [MovieModel] = []
    var selectedMovie: MovieModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchController.searchBar.placeholder = "Search Movies..."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "Now Playing"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apiManager.delegate = self
        apiManager.fetchMovieToday()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showMovieDetail" {
            if let vc = segue.destination as? DetailMovieViewController{
                vc.movie = self.selectedMovie
            }
        }
    }
}

extension MovieViewController: APIManagerDelegate {
    func didUpdateResult(_ apiManager: APIManager, result: Data) {
        DispatchQueue.main.async {
            if let list = parseJSONMovieAll(result){
                self.movieList = list
                self.movieTableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension MovieViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text{
            if keyword.count > 0 {
                apiManager.fetchSearchMovie(query: keyword)
            }
        }
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = movieList[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.movieOverview.text = movie.overview
        cell.movieVoteAverage.text = "Rate Average: \(movie.voteAverage)"
        
        DispatchQueue.global().async {
            if let url = URL(string: "https://image.tmdb.org/t/p/w185/\(movie.poster)"){
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let result = data {
                        cell.moviePoster.image = UIImage(data: result)
                    }
                }
            }
        }
        
        return cell
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movieList[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
}
