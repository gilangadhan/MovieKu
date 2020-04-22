//
//  SecondViewController.swift
//  MovieKu
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class TvViewController: UIViewController {
    
    var apiManager = APIManager()
    var listTv: [TvModel] = []
    var selectedTv: TvModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tvTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.placeholder = "Search Tv Show..."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater =  self
        
        tvTableView.dataSource = self
        tvTableView.delegate = self
        tvTableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "On The Air"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apiManager.delegate = self
        apiManager.fetchTvToday()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showTvDetail" {
            if let vc = segue.destination as? DetailTvViewController{
                vc.tv = self.selectedTv
            }
        }
    }
}

extension TvViewController: APIManagerDelegate {
    func didUpdateResult(_ apiManager: APIManager, result: Data) {
        DispatchQueue.main.async {
            if let list = parseJSONTvAll(result){
                self.listTv = list
                self.tvTableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension TvViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text{
            if keyword.count > 0 {
                apiManager.fetchSearchTv(query: keyword)
            }
        }
    }
}


extension TvViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listTv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvCell", for: indexPath) as! TvTableViewCell
        
        let tv = listTv[indexPath.row]
        cell.tvTitle.text = tv.name
        cell.tvOverview.text = tv.overview
        cell.tvDate.text = tv.date
        cell.tvVoteAverage.text = "Rate Average: \(tv.voteAverage)"
        
        DispatchQueue.global().async {
            if let url = URL(string: "https://image.tmdb.org/t/p/w185/\(tv.poster)"){
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let result = data {
                        cell.tvPoster.image = UIImage(data: result)
                    }
                }
            }
        }
        
        return cell
    }
}

extension TvViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTv = listTv[indexPath.row]
        performSegue(withIdentifier: "showTvDetail", sender: self)
    }
}
