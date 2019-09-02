//
//  MovieDetailVM.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 03/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

class MovieDetailVM: NSObject {
    
    let apiService = APIService.shared()
    
    func getMovieDetail(id : Int, completion : @escaping (_ success : Bool, _ detail : MovieDetail?) -> ()) {
        
        let url = String(format: APIList.getMovieDetail, id)
        
        apiService.GETAPI(url: url, completion: { result in
            switch(result) {
            case .success(let response):
                if let dict = response as? NSDictionary {
                    do {
                        let movieData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: movieData)
                        completion(true, movieDetail)
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
    
    func getMovieCast(id : Int, completion : @escaping (_ success : Bool, _ cast : [MovieCast]?) -> ()) {
        
        let url = String(format: APIList.getMovieCast, id)
        
        apiService.GETAPI(url: url, completion: { result in
            switch(result) {
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
}
