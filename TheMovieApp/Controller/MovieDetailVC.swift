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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
