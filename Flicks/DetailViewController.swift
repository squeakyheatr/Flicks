//
//  DetailViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 2/5/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var MoviePosterImage: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!
    @IBOutlet var movieScrollView: UIScrollView!
    @IBOutlet var detailLabelView: UIView!
    
    var movieDic = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: detailLabelView.frame.origin.y + detailLabelView.frame.size.height)
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let title = movieDic["title"] as! String
        let overview = movieDic["overview"] as! String
        
        movieTitleLabel.text = title
        movieOverviewLabel.text = overview
        movieOverviewLabel.sizeToFit()
        
        
        if let posterPath = movieDic["poster_path"] as? String  {
            
            let imageURL = NSURL(string: baseURL + posterPath)
            MoviePosterImage.setImageWith(imageURL! as URL)
        }
        
        self.navigationItem.title = title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
