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

struct MovieDetail : Codable {
    let id : Int
    let title : String
    let vote_average : Float?
    let backdrop_path : String?
    let release_date : String?
    let spoken_languages : [Language]?
    let genres : [Genre]?
    let vote_count : Int?
    let runtime : Int?
    let overview : String?
}

struct MovieCast : Codable {
    let character : String
    let name : String
}

struct Language : Codable {
    let name : String
}

struct Genre : Codable {
    let name : String
}

extension Array where Element == Language {
    
    func getCommaSeparatedValues() -> String {
        
        var value = ""
        
        for language in self {
            if !value.isEmpty {
                value = value + ", \(language.name)"
            } else {
                value = language.name
            }
        }
        
        return value
    }
}

extension Array where Element == Genre {
    
    func getCommaSeparatedValues() -> String {
        
        var value = ""
        
        for genre in self {
            if !value.isEmpty {
                value = value + ", \(genre.name)"
            } else {
                value = genre.name
            }
        }
        
        return value
    }
}

extension Array where Element == MovieCast {
    
    func getCastValues() -> String {
        
        var value = ""
        
        for cast in castList {
            if !value.isEmpty {
                value = value + "\n\(cast.character)(\(cast.name))"
            } else {
                value = "\(cast.character) (\(cast.name))"
            }
        }
        
        if !value.isEmpty {
            value = "Cast:\n" + value
            return value
        } else {
            return value
        }
    }
}
