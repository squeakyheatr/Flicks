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
 
 

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var MovieSearchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet var MovieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
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

            
        MovieTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "didRefreshList", for: .valueChanged )
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies{
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let movie = movies![indexPath.row]
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
                    
                    
                    
                    print("is refreshing")
                }
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()
    }
    


}
