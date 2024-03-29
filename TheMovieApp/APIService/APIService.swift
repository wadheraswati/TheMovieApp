//
//  APIService.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

public enum RequestType: String {
    case GET
}

class APIService: NSObject {
    
    static let apikey = "f66bf8df432e32edb3a4f31972f7569b"

    public typealias CompletionHandler = ( Result <Any, AppError> ) -> Void

    static func appendApiKeyToUrl(_ url: String) -> String {
        
        var urlString = url
        if urlString.contains("?") {
            urlString.append("&api_key=\(apikey)")
        } else {
            urlString.append("?api_key=\(apikey)")
        }
        return urlString
    }
    
    static func get(url: String, completion: @escaping CompletionHandler) {
        
        let formattedUrl = self.appendApiKeyToUrl(url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let apiUrl = formattedUrl, let urlString = URL(string: apiUrl) else {
            print("Bad URL")
            completion(.failure(.badURL))
            return
        }
        
        print("GET API Called - \(apiUrl)")
        
        var request = URLRequest(url: urlString)
        request.httpMethod = RequestType.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, _, error -> Void in
            
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
