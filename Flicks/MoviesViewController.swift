 //
//  MoviesViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 1/29/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
 
 

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var errorView: UIView!
    
    var movies: [NSDictionary]?
    
    var filteredMovies: [NSDictionary]?
    
    
    
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet var MovieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTableView.dataSource = self
        searchBar.delegate = self

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.errorView.isHidden = true

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)

                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredMovies = self.movies
                    self.MovieTableView.reloadData()
                    
                } else {
                    self.errorView.isHidden = false
                    MBProgressHUD.showAdded(to: self.errorView, animated: true)
                }
            }
        }
        task.resume()

        
        
        MovieTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "didRefreshList", for: .valueChanged )
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = filteredMovies{
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let movie = filteredMovies![indexPath.row]
        
        
        let overview = movie["overview"] as! String
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        
        cell.MovieImageView.alpha = 0
        cell.MovieImageView.setImageWith(imageURL! as URL)
        UIView.animate(withDuration: 1, animations: {
            cell.MovieImageView.alpha = 1
        })
        cell.TitleLabel.text = title
        cell.OverViewLabel.text = overview

        
        return cell
    }

   func didRefreshList(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.MovieTableView.reloadData()
                    
                    
                }
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        
        MovieTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = "Search"
        searchBar.resignFirstResponder()
    }
    


}
 
