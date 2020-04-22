//
//  DetailMovieViewController.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 14/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieButtonFavorite: UIBarButtonItem!
    
    var movie: MovieModel?
    var favoriteState = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         checkFavorite()
     }
    
    func setupView(){
        if let result = movie{
            movieTitle.text = result.title
            movieOverview.text = result.overview
            movieDate.text = result.date
            movieVoteAverage.text = "Rate Average: \(result.voteAverage)"
            
            DispatchQueue.global().async {
                if let urlBackdrop = URL(string: "https://image.tmdb.org/t/p/w185/\(result.backdrop)"),
                    let urlPoster = URL(string: "https://image.tmdb.org/t/p/w185/\(result.poster)"){
                    
                    let dataPoster = try? Data(contentsOf: urlPoster)
                    let dataBackdrop = try? Data(contentsOf: urlBackdrop)
                    DispatchQueue.main.async {
                        if let poster = dataPoster, let backdrop = dataBackdrop {
                            self.moviePoster.image = UIImage(data: poster)
                            self.movieBackdrop.image = UIImage(data: backdrop)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if let favorite = movie {
            if favoriteState {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntities")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id = %d", favorite.id)
                
                var result: [NSManagedObject] = []
                do { result = try context.fetch(fetchRequest) }
                catch { print("error executing fetch request: \(error)")}
                
                if let memberToDelete = result.first {
                    self.context.delete(memberToDelete)
                    do {
                        try self.context.save()
                        favoriteState = false
                        updateFavoriteView()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                let entities = MovieEntities(context: context)
                
                entities.id = Int32(favorite.id)
                entities.title = favorite.title
                entities.poster = favorite.poster
                entities.backdrop = favorite.backdrop
                entities.date = favorite.date
                entities.overview = favorite.overview
                entities.voteAverage = favorite.voteAverage
                
                do {
                    try context.save()
                    favoriteState = true
                    updateFavoriteView()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func checkFavorite() {
        if let favorite = movie {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntities")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id = %d", favorite.id)
            
            var results: [NSManagedObject] = []
            do { results = try context.fetch(fetchRequest) }
            catch { print("error executing fetch request: \(error)")}
            
            if results.count > 0 {
                favoriteState = true
            } else{
                favoriteState = false
            }
            updateFavoriteView()
        }
    }
    
    func updateFavoriteView(){
        if self.favoriteState {
            movieButtonFavorite.image = UIImage(named: "Favorited")
        } else {
            movieButtonFavorite.image = UIImage(named: "UnFavorited")
        }
    }
}


