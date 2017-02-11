//
//  MoviesCollectionViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 2/3/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit
import AFNetworking


class MoviesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
   
    var movies: [NSDictionary]?
    
    var filteredMovies: [NSDictionary]?
    
    var endPoint = String()
    
    
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        changeTitle()
        
        self.navigationItem.leftBarButtonItem?.title = "List"
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        
        searchBar.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                        
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredMovies = self.movies

                    self.moviesCollectionView.reloadData()
                    
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let movies = filteredMovies{
            return movies.count
        } else {
            return 0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
    
        let lowBaseURL = "https://image.tmdb.org/t/p/w45"
        let highBaseURL = "https://image.tmdb.org/t/p/w500"
        
        let movie = filteredMovies![indexPath.row]

        
        if let posterPath = movie["poster_path"] as? String {
        
        
        let lowImageURL = NSURL(string: lowBaseURL + posterPath)
        
        let highImageURL = NSURL(string: highBaseURL + posterPath)
        
        let smallImageRequest = NSURLRequest(url: lowImageURL as! URL)
        let largeImageRequest = NSURLRequest(url: highImageURL as! URL)
        
        
        
        //cell.MovieImageView.setImageWith(imageURL! as URL)
        
        cell.MovieCollectionImage.setImageWith(
            smallImageRequest as URLRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.MovieCollectionImage.alpha = 0.0
                cell.MovieCollectionImage.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    cell.MovieCollectionImage.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    cell.MovieCollectionImage.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            cell.MovieCollectionImage.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })

        }
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        
        moviesCollectionView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = "Search"
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segCell = sender as! UICollectionViewCell
        let indexPath = moviesCollectionView.indexPath(for: segCell)
        let segMovie = movies![indexPath!.row]
            
        let detailsVC = segue.destination as! DetailViewController
        
        detailsVC.movieDic = segMovie
    }
    
    func changeTitle(){
        if endPoint == "now_playing" {
            self.navigationItem.title = "Now Playing"
        } else if endPoint == "top_rated" {
            self.navigationItem.title = "Top Rated"
        } else {
            self.navigationItem.title = "Upcoming"
        }
        
    }
    
    @IBAction func backView(_ sender: Any) {
        
  self.navigationController?.popViewController(animated: true)
    }
    
}
