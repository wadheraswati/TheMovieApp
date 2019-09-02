//
//  ViewController.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var movieTV : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var currentPage = 1
    var totalPages : Int!
    var movieList = [Movie]()

    let movieListVM = MovieListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList()

        // Do any additional setup after loading the view.
    }
    
    func getMovieList() {
        movieListVM.getPopularMovies(page : currentPage, completion: { (success, movies, page, totalPages) in
            if success {
                if let page = page, let totalPages = totalPages, let movies = movies, !movies.isEmpty {
                    AppLoader.hideLoaderIn(self.view)
                    self.currentPage = page
                    self.totalPages = totalPages
                    if self.currentPage == 1 {
                        self.movieList = movies
                    } else {
                        self.movieList.append(contentsOf: movies)
                    }
                    DispatchQueue.main.async {
                        self.movieTV.reloadData()
                    }
                }
            }
        })
    }


}

