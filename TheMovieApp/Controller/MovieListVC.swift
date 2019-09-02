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
        if currentPage == 1 {
            if let loader = self.view.viewWithTag(AppConstant.loaderTag) {
                (loader as! AppLoader).showLoaderWithMessage("Loading Popular Movies...")
            } else {
                let loader = AppLoader(frame: self.view.bounds)
                self.view.addSubview(loader)
                loader.showLoaderWithMessage("Loading Popular Contacts...")
            }
        }
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
                } else {
                    AppLoader.showErrorIn(view: self.view, withMessage: "No Popular Movies Found")
                }
            } else {
                AppLoader.showErrorIn(view: self.view, withMessage: "Something went wrong. Please try again later")
            }
        })
    }
}

private let cellIdentifier =  "movieCell"
private typealias PopularTableView = MovieListVC
extension PopularTableView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        let movie = movieList[indexPath.row]
        
        cell.titleLbl.text = movie.title
        if movie.vote_average > 0 {
            cell.ratingLbl.text = "★ \(movie.vote_average)"
        } else {
            cell.ratingLbl.text = "No Rating Available"
        }
        
        return cell
    }
}


