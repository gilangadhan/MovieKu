//
//  TvFavoriteViewController.swift
//  DicodingMediaPlayer
//
//  Created by Gilang Ramadhan on 15/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class TvFavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTvTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var listTv: [TvEntities] = []
    var selectedTv: TvModel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTvTableView.dataSource = self
        favoriteTvTableView.delegate = self
        favoriteTvTableView.rowHeight = UITableView.automaticDimension
        favoriteTvTableView.estimatedRowHeight = UITableView.automaticDimension
    
        emptyView.visibility = .visible
        favoriteTvTableView.visibility = .gone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let memberFect = NSFetchRequest<NSFetchRequestResult>(entityName: "TvEntities")
            listTv = try context.fetch(memberFect) as! [TvEntities]
            if listTv.count > 0 {
                emptyView.visibility = .gone
                favoriteTvTableView.visibility = .visible
            } else {
                emptyView.visibility = .visible
                favoriteTvTableView.visibility = .gone
            }
        } catch {
            print(error.localizedDescription)
        }
        
        self.favoriteTvTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showTvDetail" {
            if let vc = segue.destination as? DetailTvViewController{
                vc.tv = self.selectedTv
            }
        }
    }
}

extension TvFavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvFavoriteCell", for: indexPath) as! TvFavoriteTableViewCell
        
        let tv = listTv[indexPath.row]
        cell.tvFavoriteTitle.text = tv.name
        cell.tvFavoriteOverview.text = tv.overview
        cell.tvFavoriteDate.text = tv.date
        cell.tvFavoriteVoteAverage.text = "Rate Average: \(tv.voteAverage)"
        
        DispatchQueue.global().async {
            if let poster = tv.poster, let url = URL(string: "https://image.tmdb.org/t/p/w185/\(poster)"){
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let result = data {
                        cell.tvFavoritePoster.image = UIImage(data: result)
                    }
                }
            }
        }
        
        return cell
    }
}

extension TvFavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tv = listTv[indexPath.row]
        if let name = tv.name, let date = tv.date, let backdrop = tv.backdrop, let overview = tv.overview, let poster = tv.poster {
            selectedTv = TvModel(id: Int(tv.id), name: name, date: date, backdrop: backdrop, overview: overview, poster: poster, voteAverage: tv.voteAverage)
            performSegue(withIdentifier: "showTvDetail", sender: self)
        }
    }
}
