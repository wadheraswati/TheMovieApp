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
    var movieDetail : MovieDetail!

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
    
    func setUpCastLbl(withCast cast : [MovieCast]?) {
        var text = ""
        if let movieCast = cast {
            text = movieCast.getCastValues()
        } else {
            text = "Cast : Not Available"
        }
        DispatchQueue.main.async {
            self.setAttributes(toLabel: self.castLbl, forKey: "Cast", andText: text)
            self.perform(#selector(self.viewDidLayoutSubviews), with: nil, afterDelay: 0.5)
        }
    }
    
    func setupUI() {
        
        DispatchQueue.main.async {
            
            self.movieTitleLbl.text = self.movieDetail.title
            
            var text = ""
            if let runTime = self.movieDetail.runtime, runTime > 0 {
                let hour = runTime/60
                let min = runTime%60
                text = "Duration : \(hour) hour\(hour > 1 ? "s" : "") \(min) min\(min > 1 ? "s" : "")"
            } else {
                text = "Duration : Not Available"
            }
            
            self.setAttributes(toLabel: self.runningTimeLbl, forKey: "Duration", andText: text)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let releaseDate = self.movieDetail.release_date, let dateResult = dateFormatter.date(from: releaseDate) {
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let formattedDate = dateFormatter.string(from: dateResult)
                text = "Release Date : \(formattedDate)"
            } else {
                text = "Release Date : Not Available"
            }
            
            self.setAttributes(toLabel: self.releaseDateLbl, forKey: "Release Date", andText: text)
            
            if let languages = self.movieDetail.spoken_languages, !languages.isEmpty {
                text = "Languages : \(languages.getCommaSeparatedValues())"
            } else {
                text = "Languages : Not Available"
            }
            
            self.setAttributes(toLabel: self.languageLbl, forKey: "Languages", andText: text)
            
            if let genres = self.movieDetail.genres, !genres.isEmpty {
                text = "Genres : \(genres.getCommaSeparatedValues())"
            } else {
                text = "Genres : Not Available"
            }
            
            self.setAttributes(toLabel: self.genreLbl, forKey: "Genres", andText: text)
            
            var ratingValue = ""
            if let rating = self.movieDetail.vote_average, rating > 0 {
                ratingValue = "★ \(rating)"
            }
            if let voteCount = self.movieDetail.vote_count, voteCount > 0 {
                ratingValue = ratingValue + "\(ratingValue.isEmpty ? "" : " & ")\(voteCount) votes"
            }
            text = ratingValue.isEmpty ? "Rating : Not Available" : "Rating : \(ratingValue)"
            
            self.setAttributes(toLabel: self.ratingLbl, forKey: "Rating", andText: text)
            
            if let synopsis = self.movieDetail.overview, !synopsis.isEmpty {
                text = "About:\n\(synopsis)"
            } else {
                text = "About : Not Available"
            }
            
            self.setAttributes(toLabel: self.synopsisLbl, forKey: "About", andText: text)
            
            if let backdrop =  self.movieDetail.backdrop_path {
                let imageUrl = String(format: APIList.imageBaseUrl, backdrop)
                self.posterImgV.loadImageUsingCache(withUrl : imageUrl)
            }
        }
    }
    
    func setAttributes(toLabel label : UILabel, forKey key: String, andText text: String) {
        let attr = NSMutableAttributedString(string : text)
        attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: attr.length))
        attr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: attr.mutableString.range(of: key))
        label.attributedText = attr
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
