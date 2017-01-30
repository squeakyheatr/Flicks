 //
//  MoviesViewController.swift
//  Flicks
//
//  Created by Robert Mitchell on 1/29/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITabBarDelegate{

    @IBOutlet var MovieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel!.text = "Row \(indexPath.row)"
        print("Row \(indexPath.row)")
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
