//
//  FavoriteViewController.swift
//  MovieKu
//
//  Created by Gilang Ramadhan on 13/04/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var segmentFavorite: UISegmentedControl!
    @IBOutlet weak var movieContainer: UIView!
    @IBOutlet weak var tvContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Favorite"
        if let navigation = self.navigationController{
            navigation.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
            navigation.navigationBar.tintColor = .white
            navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigation.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]    }
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            movieContainer.alpha = 1
            tvContainer.alpha = 0
        } else {
            tvContainer.alpha = 1
            movieContainer.alpha = 0
        }
    }
}
