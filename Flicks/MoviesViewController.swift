 //
//  MoviesViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 1/29/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
// add launchs screen
// add app logo
 // google search tools -> usage rights -> labeled for reuse, or label for reuse with modification
 // also can pay for usage rights 1 time fee
 

import UIKit
import AFNetworking
import MBProgressHUD
 
 

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var errorView: UIView!
    
    var movies: [NSDictionary]?
    
    var filteredMovies: [NSDictionary]?
    
    var endPoint = String()
    
    
    
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet var MovieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTableView.dataSource = self
        searchBar.delegate = self
        
        navigationController!.navigationBar.barTintColor = UIColor.lightGray
        navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "AmericanTypewriter-Bold", size: 17)!,
              NSForegroundColorAttributeName: UIColor.red])
        
        self.navigationItem.rightBarButtonItem?.title = "Posters"
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)

        
        
        changeTitle()
        

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.errorView.isHidden = true

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
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

        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        let lowBaseURL = "https://image.tmdb.org/t/p/w45"
        let highBaseURL = "https://image.tmdb.org/t/p/w500"
        
        let movie = filteredMovies![indexPath.row]
        
        
        let overview = movie["overview"] as! String
        let title = movie["title"] as! String
        
        if let posterPath = movie["poster_path"] as? String  {
            
            let lowImageURL = NSURL(string: lowBaseURL + posterPath)

            let highImageURL = NSURL(string: highBaseURL + posterPath)
            
            let smallImageRequest = NSURLRequest(url: lowImageURL as! URL)
            let largeImageRequest = NSURLRequest(url: highImageURL as! URL)

        
            
            //cell.MovieImageView.setImageWith(imageURL! as URL)
            
            cell.MovieImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.MovieImageView.alpha = 0.0
                    cell.MovieImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.MovieImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        cell.MovieImageView.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                cell.MovieImageView.image = largeImage;
                                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            
            let segCell = sender as! UITableViewCell
            let indexPath = MovieTableView.indexPath(for: segCell)
            let segMovie = movies![indexPath!.row]
        
            let detailsVC = segue.destination as! DetailViewController
            
            detailsVC.movieDic = segMovie
        } else {
            
            let movieCollectionVC = segue.destination as! MoviesCollectionViewController
            movieCollectionVC.endPoint = endPoint
        }
     
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

}
 
