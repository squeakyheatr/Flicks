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

class MoviesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
   
    var movies: [NSDictionary]?
    
    var filteredMovies: [NSDictionary]?
    
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
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
    
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let movie = filteredMovies![indexPath.row]

        
        let overview = movie["overview"] as! String
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        
        cell.MovieCollectionImage.alpha = 0
        cell.MovieCollectionImage.setImageWith(imageURL! as URL)
        UIView.animate(withDuration: 1, animations: {
            cell.MovieCollectionImage.alpha = 1
        })
       
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
}
