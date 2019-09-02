//
//  APIService.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

public enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

public enum ResponseStatusCode : Int {
    case Success = 200
    case NoData = 204
    case SessionExpired = 401
}

class APIService : NSObject {
    
    private static var sharedManager: APIService = {
        let serviceManager = APIService()
        
        return serviceManager
    }()
    
    @objc open class func shared() -> APIService {
        return sharedManager
    }
    
    public typealias completionHandler = ( Result <Any, AppError> ) -> Void

    func GETAPI(url : String, completion : @escaping completionHandler)
    {
        
        guard let apiUrl = url, let urlString = URL(string : apiUrl) else {
            print("Bad URL")
            completion(.failure(.badURL))
            return
        }
        
        print("GET API Called - \(apiUrl)")
        
        var request = URLRequest(url: urlString)
        request.httpMethod = RequestType.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                if error == nil {
                    let json = try JSONSerialization.jsonObject(with: data!)
                    print("GET API - \(url) Response")
                    completion(.success(json))
                } else {
                    print("GET API - \(url) Error - \(error?.localizedDescription ?? "")")
                    completion(.failure(.badURL))
                }
            } catch {
                print("error")
                completion(.failure(.badURL))
            }
        })
        
        task.resume()
    }
}

enum AppError: Error {
    case badURL
}
