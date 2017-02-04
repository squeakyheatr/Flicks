//
//  MoviesCollectionViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 2/3/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit
import AFNetworking

private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

   
    var movies: [NSDictionary]?
    
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                        
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.moviesCollectionView.reloadData()
                    
                    
                    
                    
                }
            }
        }
        task.resume()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let movies = movies{
            return self.movies!.count
        } else {
            return 0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
    
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let movie = self.movies![indexPath.row]
        let overview = movie["overview"] as! String
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        
        cell.MovieCollectionImage.setImageWith(imageURL! as URL)
        cell.MovieCollectionTitle.text = title
        cell.MovieCollectionOverView.text = overview
       
        return cell
    }


}
