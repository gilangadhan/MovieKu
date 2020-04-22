//
//  DetailTvViewController.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 14/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class DetailTvViewController: UIViewController {
    
    @IBOutlet weak var tvPoster: UIImageView!
    @IBOutlet weak var tvBackdrop: UIImageView!
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var tvVoteAverage: UILabel!
    @IBOutlet weak var tvOverview: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvButtonFavorite: UIBarButtonItem!
    
    var tv: TvModel?
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
        if let result = tv {
            tvName.text = result.name
            tvOverview.text = result.overview
            tvDate.text = result.date
            tvVoteAverage.text = "Rate Average: \(result.voteAverage)"
            
            DispatchQueue.global().async {
                if let urlBackdrop = URL(string: "https://image.tmdb.org/t/p/w185/\(result.backdrop)"),
                    let urlPoster = URL(string: "https://image.tmdb.org/t/p/w185/\(result.poster)"){
                    
                    let dataPoster = try? Data(contentsOf: urlPoster)
                    let dataBackdrop = try? Data(contentsOf: urlBackdrop)
                    DispatchQueue.main.async {
                        if let poster = dataPoster, let backdrop = dataBackdrop {
                            self.tvPoster.image = UIImage(data: poster)
                            self.tvBackdrop.image = UIImage(data: backdrop)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        if let favorite = tv {
            if favoriteState {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TvEntities")
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
                let entities = TvEntities(context: context)
                
                entities.id = Int32(favorite.id)
                entities.name = favorite.name
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
        if let favorite = tv {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TvEntities")
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
            tvButtonFavorite.image = UIImage(named: "Favorited")
        } else {
            tvButtonFavorite.image = UIImage(named: "UnFavorited")
        }
    }
}
