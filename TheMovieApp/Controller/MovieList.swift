//
//  ViewController.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

class MovieList: UIViewController {

    @IBOutlet weak var movieTV : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var currentPage = 1
    var totalPages : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getMovieList()

        // Do any additional setup after loading the view.
    }


}

