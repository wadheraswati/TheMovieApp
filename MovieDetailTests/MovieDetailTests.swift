//
//  MovieDetailTests.swift
//  MovieDetailTests
//
//  Created by Swati Wadhera on 03/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import XCTest
@testable import TheMovieApp

class MovieDetailTests: XCTestCase {
    
    var sut: MovieDetailVC!
    
    override func setUp() {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVCIdentifier") as? MovieDetailVC
        sut.loadViewIfNeeded()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNotNilMovieId() {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVCIdentifier") as? MovieDetailVC
        XCTAssertNil(sut.movieId)
        sut.movieId = 1
        sut.loadViewIfNeeded()
        sut.viewDidLayoutSubviews()
    }
    
    func testMovieDetails() {
        sut.movieId = 420818
        sut.getMovieDetail()
    }
    
    func testNotExistingMovieDetails() {
        sut.movieId = 1
        sut.getMovieDetail()
    }
    
    func testDummyNilMovieDetail() {
        sut.movieDetail = MovieDetail(id: 1, title: "", vote_average: 0, backdrop_path: nil, release_date: "", spoken_languages: nil, genres: nil, vote_count: 0, runtime: 0, overview: nil)
        sut.setupUI()
        sut.setUpCastLbl(withCast: nil)
        
    }
    
    func testRandomDummyData() {
        sut.movieDetail = MovieDetail(id: 1, title: "Movie Title", vote_average: 4.6, backdrop_path: nil, release_date: "24324", spoken_languages: [], genres: [], vote_count: 0, runtime: 60, overview: nil)
        sut.setupUI()
        sut.setUpCastLbl(withCast: nil)
    }
    
    func testCastDummyData() {
        sut.movieDetail = MovieDetail(id: 1, title: "Movie Title", vote_average: 4.6, backdrop_path: nil, release_date: "24324", spoken_languages: [], genres: [], vote_count: 500, runtime: 61, overview: nil)
        sut.setupUI()
        sut.setUpCastLbl(withCast: [MovieCast(character: "New", name: "Name")])
    }
    
    func testVoteCountWithVoteAverage() {
        sut.movieDetail = MovieDetail(id: 1, title: "Movie Title", vote_average: 0, backdrop_path: nil, release_date: "24324", spoken_languages: [], genres: [], vote_count: 500, runtime: 160, overview: nil)
        sut.setupUI()
        sut.setUpCastLbl(withCast: [MovieCast(character: "New", name: "Name")])
    }
}
