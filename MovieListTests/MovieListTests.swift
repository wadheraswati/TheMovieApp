//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Swati Wadhera on 03/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import XCTest
@testable import TheMovieApp

class MovieListTests: XCTestCase {
    
    var sut : MovieListVC!
    
    override func setUp() {
        
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListVCIdentifier") as? MovieListVC
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.movieTV,
                        "Controller should have a tableview")
        XCTAssertNotNil(sut.movieTV.delegate, "Table View Delegate is not attached")
        XCTAssertNotNil(sut.movieTV.dataSource, "Table View DataSource is not attached")
        XCTAssertNotNil(sut.searchBar.delegate, "Search Bar Delegate not connected")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPullToRefresh() {
        sut.refreshControl.beginRefreshing()
        sut.refresh(sut.refreshControl)
    }
    
    func testDummyData() {
        let testBundle = Bundle(for: type(of: self))
        
        if let path = testBundle.path(forResource: "PopularDummyData", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped), let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary, let list = dict.value(forKey: "results") as? NSArray {
            var dummyMovieList = [Movie]()
            do {
                for movieObj in list {
                    let movieData = try JSONSerialization.data(withJSONObject: movieObj, options: .prettyPrinted)
                    let movie = try JSONDecoder().decode(Movie.self, from: movieData)
                    dummyMovieList.append(movie)
                }
                sut.movieList = dummyMovieList
                sut.movieTV.reloadData()
                let index = Int.random(in: 0..<sut.movieList.count)
                sut.movieTV.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
            }
            catch {
                print("error - \(error)")
            }
        }
    }
    
    func testMovieDetail() {
        let myExpectation = expectation(description: "movielist count")
        
        XCTWaiter().wait(for: [myExpectation], timeout: 3)
        if !sut.movieList.isEmpty {
            sut.selectedRow = Int.random(in: 0..<sut.movieList.count)
            sut.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
        }
    }
    
    func testSearchMovieDetail() {
        var dummyMovieList = [Movie]()
        for i in 1...5 {
            let movie = Movie(id: 1, title: "Movie Title \(i)", vote_average: Float(i), poster_path: nil)
            dummyMovieList.append(movie)
        }
        sut.isSearchOn = true
        sut.searchList = dummyMovieList
        sut.selectedRow = Int.random(in: 0..<sut.searchList.count)
        sut.performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
    
    func testMaxPage() {
        sut.currentPage = 1234567
        sut.getMovieList()
    }
    
    func testNextPage() {
        sut.currentPage = 2
        sut.getMovieList()
    }
    
    
    func testSearch() {
        sut.searchBar.becomeFirstResponder()
        sut.searchBar.text = "ab"
        sut.getSearchResults()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
