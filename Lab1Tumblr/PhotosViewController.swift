//
//  PhotosViewController.swift
//  Lab1Tumblr
//
//  Created by Sarah Gemperle on 1/19/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var posts: [NSDictionary]? = []
    @IBOutlet weak var tableView: UITableView!
    var imgURL: URL!
    var isMoreDataLoading = false
    var offset: Int?
    var loadingMoreView:InfiniteScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure data source and delegate for our table view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (refreshControlAction), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
        loadingMoreView = InfiniteScrollView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollView.defaultHeight;
        tableView.contentInset = insets
        
        self.refresh()


    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.refresh()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    //Override func for DataSource.
    //Establishes number of rows for our table view.
    //Param: 1- table view 
    //       2- int value declaring num rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let posts = posts {
            print("TOTAL POSTS COUNT IS:  \(posts.count)")
            return posts.count
        } else {
            return 0
        }

    }
    
    //Override func for DataSource
    //Determines the content/behavior for each cell in our table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        //An array of dictionaries at the index in posts of the tableView row.
        let post = posts![indexPath.row]
        
        //Safely access photos array in the curent post in row.
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            //Create URL path for the photo attached to the post using AFNetworking and URL.
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            let imageUrl = URL(string: imageUrlString!)!
            cell.imgURL = imageUrl
            cell.cellImage.setImageWith(imageUrl)
            
            
        } else {
            // photos is nil.
        }
        
        return cell
    }
    
    //Get rid of gray selection effect of cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! PhotoDetailsViewController
        let idxPath = tableView.indexPath(for: sender as! PhotoCell)
        
        let cell = tableView.cellForRow(at: idxPath!) as! PhotoCell
        
        vc.photoURL = cell.imgURL
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func refresh(){
        //fetch data and reload tableview after completion
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as? [NSDictionary]
                        self.tableView.reloadData()
                        self.offset = self.posts?.count
                        
                    }
                }
        });
        task.resume()
    }
    
    func loadMoreData() {
        
        // Configure session so that completion handler is executed on main UI thread
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset)")
        let request = URLRequest(url: url!)

        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        // Update flag
                        self.isMoreDataLoading = false
                        
                        // ... Use the new data to update the data source ...
                        self.posts?.append(responseFieldDictionary)
                        // Reload the tableView now that there is new data
                        self.tableView.reloadData()
                        self.loadingMoreView!.stopAnimating()
                        self.offset = self.posts?.count
            
                    }
                }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
