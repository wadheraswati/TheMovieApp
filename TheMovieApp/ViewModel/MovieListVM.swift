//
//  MovieListVM.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

class MovieListVM: NSObject {

    let apiService = APIService.shared()

    func getPopularMovies(page : Int, completion : @escaping (_ success : Bool, _ movieList : [Movie]?, _ currentPage : Int?, _ totalPages : Int?) -> ()) {
        
        let url = String(format: APIList.getPopularMovies, page)
        
        apiService.GETAPI(url: url, completion: { result in
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
    
    func searchMovie(page : Int, query : String, completion : @escaping (_ success : Bool, _ movieList : [Movie]?, _ currentPage : Int?, _ totalPages : Int?) -> ()) {
        
        let url = String(format: APIList.searchMovie, query, page)
        
        apiService.GETAPI(url: url, completion: { result in
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
    
    
}
