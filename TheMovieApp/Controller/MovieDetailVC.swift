//
//  MovieDetailVC.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 02/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    @IBOutlet weak var movieTitleLbl : UILabel!
    @IBOutlet weak var runningTimeLbl : UILabel!
    @IBOutlet weak var releaseDateLbl : UILabel!
    @IBOutlet weak var languageLbl : UILabel!
    @IBOutlet weak var genreLbl : UILabel!
    @IBOutlet weak var ratingLbl : UILabel!
    @IBOutlet weak var synopsisLbl : UILabel!
    @IBOutlet weak var castLbl : UILabel!
    
    @IBOutlet weak var posterImgV : UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!

    var movieId : Int!
    let movieDetailVM = MovieDetailVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        if movieId != nil {
            getMovieDetail()
        }
        // Do any additional setup after loading the view.
    }
    
    func getMovieDetail() {
        
        let loader = AppLoader(frame: self.view.bounds)
        self.view.addSubview(loader)
        loader.showLoaderWithMessage("Loading Movie Details...")
        
        movieDetailVM.getMovieDetail(id: movieId, completion: { (success, movieDetail) in
            if success, let detail = movieDetail {
                self.movieDetail = detail
                self.setupUI()
                AppLoader.hideLoaderIn(self.view)
            } else {
                AppLoader.showErrorIn(view: self.view, withMessage: "Something went wrong. Please try again later")
            }
        })
        
        movieDetailVM.getMovieCast(id: movieId, completion: { (success, movieCast) in
            self.setUpCastLbl(withCast: movieCast)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
