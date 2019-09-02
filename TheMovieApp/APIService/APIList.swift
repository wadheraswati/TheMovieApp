//
//  APIList.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

struct APIList: Codable {
    
    static let getPopularMovies = "https://api.themoviedb.org/3/movie/popular?page=%d"
    static let searchMovie = "https://api.themoviedb.org/3/search/movie?query=%@&page=%d"

    static let imageBaseUrl = "https://image.tmdb.org/t/p/w200%@"
    
}
