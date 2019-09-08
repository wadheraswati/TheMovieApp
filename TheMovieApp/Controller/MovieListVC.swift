//
//  ViewController.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit
import Cachable

class MovieListVC: UIViewController {

    @IBOutlet weak var movieTV : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var currentPage = 1
    var totalPages : Int!
    var currentSearchPage = 1
    var totalSearchPages : Int!
    
    var movieList = [Movie]()
    var searchList = [Movie]()

    var isSearchOn = false
    var selectedRow : Int!

    let movieListVM = MovieListVM()
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        movieTV.addSubview(refreshControl)
        
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
                loader.showLoaderWithMessage("Loading Popular Movies...")
            }
        }
        movieListVM.getPopularMovies(page : currentPage, completion: { (success, movies, page, totalPages, errorMsg) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
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
                AppLoader.showErrorIn(view: self.view, withMessage: errorMsg ?? "Something went wrong. Please try again later")
            }
        })
    }
    
    // MARK: - Helper Methods -
    @objc func refresh(_ sender : AnyObject) {
        currentPage = 1
        currentSearchPage = 1
        searchBar.text = ""
        isSearchOn = false
        getMovieList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            let vc = segue.destination as! MovieDetailVC
            vc.movieId = isSearchOn ? searchList[selectedRow].id : movieList[selectedRow].id
        }
    }
}

private let cellIdentifier =  "movieCell"
private typealias PopularTableView = MovieListVC
extension PopularTableView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchOn ? searchList.count : movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        let movie = isSearchOn ? searchList[indexPath.row] : movieList[indexPath.row]

        cell.titleLbl.text = movie.title
        if movie.vote_average > 0 {
            cell.ratingLbl.text = "★ \(movie.vote_average)"
        } else {
            cell.ratingLbl.text = "No Rating Available"
        }
        
        if let posterImgPath = movie.poster_path {
            let imageUrl = String(format: APIList.imageBaseUrl, ImageSize.Small.rawValue, posterImgPath)
            cell.movieImgView.loadImageUsingCache(withUrl : imageUrl)
        } else {
            cell.movieImgView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSearchOn && indexPath.row == searchList.count - 5 && currentSearchPage < totalSearchPages {
            if let text = searchBar.text?.lowercased(), !text.isEmpty {
                currentSearchPage += 1
                searchMoviesWithQuery(text)
            }
        } else if indexPath.row == movieList.count - 5 && currentPage < totalPages {
            currentPage += 1
            getMovieList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
        selectedRow = indexPath.row
        performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

private typealias PopularSearchBar = MovieListVC

extension PopularSearchBar : UISearchBarDelegate {
    
    func getSearchResults() {
        if let text = searchBar.text?.lowercased(), !text.isEmpty {
            currentSearchPage = 1
            searchList.removeAll()
            searchMoviesWithQuery(text)
            isSearchOn = true
        } else {
            isSearchOn = false
        }
        
        DispatchQueue.main.async {
            self.movieTV.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            isSearchOn = false
            DispatchQueue.main.async {
                self.movieTV.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            getSearchResults()
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
    
    func searchMoviesWithQuery(_ query : String) {
        if currentSearchPage == 1 {
            if let loader = self.view.viewWithTag(AppConstant.loaderTag) {
                (loader as! AppLoader).showLoaderWithMessage("Getting Search Results...")
            } else {
                let loader = AppLoader(frame: self.view.bounds)
                self.view.addSubview(loader)
                loader.showLoaderWithMessage("Getting Search Results...")
            }
        }
        movieListVM.searchMovie(page : currentSearchPage, query: query, completion: { (success, movies, page, totalPages) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            if success {
                if let page = page, let totalPages = totalPages, let movies = movies {
                    self.currentSearchPage = page
                    self.totalSearchPages = totalPages
                    if self.currentSearchPage == 1 {
                        self.searchList = movies
                    } else {
                        self.searchList.append(contentsOf: movies)
                    }
                    DispatchQueue.main.async {
                        self.movieTV.reloadData()
                    }
                    AppLoader.hideLoaderIn(self.view)
                } else {
                    AppLoader.showErrorIn(view: self.view, withMessage: "No Results based on your query")
                }
            } else {
                AppLoader.showErrorIn(view: self.view, withMessage: "Something went wrong. Please try again later")
            }
        })
    }
}


