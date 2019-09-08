//
//  MovieDetailVM.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 03/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit
import Cachable

class MovieDetailVM: NSObject {
    
    let apiService = APIService.shared()
    let cacher: Cacher = Cacher(destination: .temporary)
    
    func getMovieDetail(movieId: Int, completion: @escaping (_ success: Bool, _ detail: MovieDetail?, _ errorMsg: String?) -> Void) {
        
        let url = String(format: APIList.getMovieDetail, movieId)
        if !Connectivity.isConnectedToInternet {
            if let movie: CachableMovieDetail = cacher.load(fileName: "movies-\(movieId)") {
                completion(true, movie.detail, nil)
            } else {
                completion(false, nil, "You are not connected to internet. Please try again later")
            }
            return
        }
        
        apiService.get(url: url, completion: { result in
            switch result {
            case .success(let response):
                if let dict = response as? NSDictionary {
                    do {
                        let movieData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: movieData)
                        completion(true, movieDetail, nil)
                        self.writeToCache(movieDetail, movieId: movieId)
                    } catch {
                        print("Parsing error - \(error)")
                        completion(false, nil, nil)
                    }
                } else {
                    completion(false, nil, nil)
                    print("failed to fetch data in proper format")
                }
            case .failure(let error):
                print("API error - \(error)")
                completion(false, nil, nil)
            }
        })
    }
    
    func getMovieCast(movieId: Int, completion: @escaping (_ success: Bool, _ cast: [MovieCast]?) -> Void) {
        
        let url = String(format: APIList.getMovieCast, movieId)
        
        apiService.get(url: url, completion: { result in
            switch result {
            case .success(let response):
                if let dict = response as? NSDictionary, let list = dict.value(forKey: "cast") as? NSArray {
                    do {
                        var castList = [MovieCast]()
                        for castObj in list {
                            let castData = try JSONSerialization.data(withJSONObject: castObj, options: .prettyPrinted)
                            let cast = try JSONDecoder().decode(MovieCast.self, from: castData)
                            castList.append(cast)
                        }
                        if !castList.isEmpty {
                            completion(true, castList)
                        } else {
                            completion(false, nil)
                        }
                    } catch {
                        print("Parsing error - \(error)")
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                    print("failed to fetch data in proper format")
                }
            case .failure(let error):
                print("API error - \(error)")
                completion(false, nil)
            }
        })
    }
    
    func writeToCache(_ detail: MovieDetail, movieId: Int) {
        let cachableMovies = CachableMovieDetail(id: movieId, detail: detail)
        self.cacher.persist(item: cachableMovies) { url, error in
            if let error = error {
                print("Movie detail failed to persist: \(error)")
            } else {
                print("Movie detail persisted in \(String(describing: url))")
            }
        }
    }
}
