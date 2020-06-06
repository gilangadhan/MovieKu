//
//  MovieFavoriteViewController.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 15/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class MovieFavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteMovieTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var listMovie: [MovieEntities] = []
    var selectedMovie: MovieModel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyView.visibility = .gone
        favoriteMovieTableView.visibility = .visible
        
        favoriteMovieTableView.dataSource = self
        favoriteMovieTableView.delegate = self
        favoriteMovieTableView.rowHeight = UITableView.automaticDimension
        favoriteMovieTableView.estimatedRowHeight = UITableView.automaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let memberFect = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntities")
            listMovie = try context.fetch(memberFect) as! [MovieEntities]
            if listMovie.count > 0 {
                emptyView.visibility = .gone
                favoriteMovieTableView.visibility = .visible
            } else {
                emptyView.visibility = .visible
                favoriteMovieTableView.visibility = .gone
            }
        } catch {
            print(error.localizedDescription)
        }
        
        self.favoriteMovieTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showMovieDetail" {
            if let vc = segue.destination as? DetailMovieViewController{
                vc.movie = self.selectedMovie
            }
        }
    }
}

extension MovieFavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieFavoriteCell", for: indexPath) as! MovieFavoriteTableViewCell
        
        let movie = listMovie[indexPath.row]
        cell.movieFavoriteTitle.text = movie.title
        cell.movieFavoriteOverview.text = movie.overview
        cell.movieFavoriteVoteAverage.text = "Rate Average: \(movie.voteAverage)"
        
        DispatchQueue.global().async {
            if let poster = movie.poster, let url = URL(string: "https://image.tmdb.org/t/p/w185/\(poster)"){
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let result = data {
                        cell.movieFavoritePoster.image = UIImage(data: result)
                    }
                }
            }
        }
        
        return cell
    }
}

extension MovieFavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listMovie[indexPath.row]
        if let title = movie.title, let date = movie.date, let backdrop = movie.backdrop, let overview = movie.overview, let poster = movie.poster {
            selectedMovie = MovieModel(id: Int(movie.id), title: title, date: date, backdrop: backdrop, overview: overview, poster: poster, voteAverage: movie.voteAverage)
            performSegue(withIdentifier: "showMovieDetail", sender: self)
        }
    }
}
