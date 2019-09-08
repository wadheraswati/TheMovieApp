//
//  MovieListVM.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit
import Cachable

class MovieListVM: NSObject {

    let apiService = APIService.shared()
    let cacher: Cacher = Cacher(destination: .temporary)

    func getPopularMovies(page: Int, completion: @escaping (_ success: Bool, _ movieList: [Movie]?, _ currentPage: Int?, _ totalPages: Int?, _ errorMsg: String?) -> Void) {
        
        let url = String(format: APIList.getPopularMovies, page)
        
        if !Connectivity.isConnectedToInternet {
            if let list: CachableMovie = cacher.load(fileName: "movies") {
                completion(true, list.movies, 1, 1, nil)
            } else {
                completion(false, nil, nil, nil, "You are not connected to internet. Please try again later")
            }
            return
        }
        
        apiService.get(url: url, completion: { result in
            switch result {
            case .success(let response):
                if let dict = response as? NSDictionary, let page = dict.value(forKey: "page") as? Int, let totalNumberOfPages = dict.value(forKey: "total_pages") as? Int, let movies = dict.value(forKey: "results") as? NSArray {
                    do {
                        var movieList = [Movie]()
                        for movieObj in movies {
                            let movieData = try JSONSerialization.data(withJSONObject: movieObj, options: .prettyPrinted)
                            let movie = try JSONDecoder().decode(Movie.self, from: movieData)
                            movieList.append(movie)
                        }
                        if page == 1 {
                            self.writeToCache(movieList)
                        }
                        completion(true, movieList, page, totalNumberOfPages, nil)
                    } catch {
                        completion(false, nil, nil, nil, nil)
                        print("parsing error - \(error.localizedDescription)")
                    }
                } else {
                    completion(false, nil, nil, nil, nil)
                    print("failed to fetch data in proper format")
                }
            case .failure(let error):
                completion(false, nil, nil, nil, nil)
                print("API error - \(error)")
            }
        })
        
    }
    
    func searchMovie(page: Int, query: String, completion: @escaping (_ success: Bool, _ movieList: [Movie]?, _ currentPage: Int?, _ totalPages: Int?) -> Void) {
        
        let url = String(format: APIList.searchMovie, query, page)
        
        apiService.get(url: url, completion: { result in
            switch result {
            case .success(let response):
                if let dict = response as? NSDictionary, let page = dict.value(forKey: "page") as? Int, let totalNumberOfPages = dict.value(forKey: "total_pages") as? Int, let movies = dict.value(forKey: "results") as? NSArray {
                    do {
                        var movieList = [Movie]()
                        for movieObj in movies {
                            let movieData = try JSONSerialization.data(withJSONObject: movieObj, options: .prettyPrinted)
                            let movie = try JSONDecoder().decode(Movie.self, from: movieData)
                            movieList.append(movie)
                        }
                        completion(true, movieList, page, totalNumberOfPages)
                    } catch {
                        completion(false, nil, nil, nil)
                        print("parsing error - \(error.localizedDescription)")
                    }
                } else {
                    completion(false, nil, nil, nil)
                    print("failed to fetch data in proper format")
                }
            case .failure(let error):
                completion(false, nil, nil, nil)
                print("API error - \(error)")
            }
        })
    }
    
    func writeToCache(_ list: [Movie]) {
        let cachableMovies = CachableMovie(movies: list)
        self.cacher.persist(item: cachableMovies) { url, error in
            if let error = error {
                print("Movies failed to persist: \(error)")
            } else {
                print("Movies persisted in \(String(describing: url))")
            }
        }
    }
}
