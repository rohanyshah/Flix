//
//  MoviesViewController.swift
//  Flix
//
//  Created by Rohan Y. Shah on 6/15/16.
//  Copyright © 2016 Rohan Y. Shah. All rights reserved.
//

import UIKit
import AFNetworking
import ARSLineProgress


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        ARSLineProgress.show()
        let apiKey = "95795956564409c9b06edf444b32d816"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                     completionHandler:
            {
                (dataOrNil, response, error) in
                if let data = dataOrNil
                {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary
                    {
                        print("response: \(responseDictionary)")
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
                ARSLineProgress.hide()
        })
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseurl = "http://image.tmdb.org/t/p/w500"
        
        let imageurl = NSURL(string: baseurl + posterPath)
        
        cell.posterView.setImageWithURL(imageurl!)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        
        print("row \(indexPath.row)")
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "95795956564409c9b06edf444b32d816"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
                                                                      completionHandler: { (data, response, error) in
                                                                        
                                                                        // ... Use the new data to update the data source ...
                                                                        
                                                                        // Reload the tableView now that there is new data
                                                                        self.tableView.reloadData()
                                                                        
                                                                        // Tell the refreshControl to stop spinning
                                                                        refreshControl.endRefreshing()	
        });
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
