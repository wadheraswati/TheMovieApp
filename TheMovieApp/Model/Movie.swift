//
//  Movie.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

struct Movie: Codable {
    let id : Int
    let title : String
    let vote_average : Float
    let poster_path : String?
}
