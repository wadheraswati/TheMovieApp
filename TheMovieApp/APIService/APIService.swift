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

}
