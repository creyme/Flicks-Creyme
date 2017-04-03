//
//  MoviesViewController.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 3/31/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {

    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorNetworkView: UIView!
    @IBOutlet weak var movieHeader: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var featuredMovieImage: UIImageView!
    @IBOutlet weak var viewbgimage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // VARIABLES
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    
    var refreshControl : UIRefreshControl!
    var refreshControlCollectionView : UIRefreshControl!
    var searchBar = UISearchBar()
    var isSearching = false
    var endpoint : String!
    var isTableView = true
    

    
    
    
    
    
// DEFAULT ---------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // FEATURED SETTINGS
        //movieHeader.backgroundColor = UIColor.clear
        let overlay = CAGradientLayer().blackTop()
        overlay.frame = movieHeader.bounds
        movieHeader.layer.insertSublayer(overlay, at: 1)
 
        // TABLEVIEW SETTINGS
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        
        // COLLECTIONVIEW SETTINGS
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear

        
        // REFRESH CONTROL
        addRefresher()
        
        // CREATE SEARCHBAR
        searchButtonOn()
        
   
        // NETWORK REQUEST
        connectToAPI()
        
        let featuredimageUrl = URL(string: "https://image.tmdb.org/t/p/original/5pAGnkFYSsFJ99ZxDIYnhQbQFXs.jpg")
        featuredMovieImage.setImageWith(featuredimageUrl!, placeholderImage: nil)
        
        //let blurBg = UIImage(named: "samplebg.jpg")
        let blurBg = viewbgimage.image
        self.view.backgroundColor = UIColor(patternImage: blurBg!)

        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, at: 1)
        
        
        
    }

    

    
    
    
    
    
// TABLEVIEW CONFIG ------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    // # OF ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    // CELL CONFIG
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        
        
        let movie = filteredMovies![indexPath.row]
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview

        // LOAD IMAGES
        
        
                let ImageUrl = "https://image.tmdb.org/t/p/w500"
                
                if let posterPath = movie["poster_path"] as? String {
                    
                    let ImageRequest = NSURLRequest(url: NSURL(string: ImageUrl + posterPath)! as URL)
                    
                    
                    cell.posterImage.setImageWith(ImageRequest as URLRequest, placeholderImage: nil, success: { (ImageRequest, ImageResponse, Image) in
                        
                        
                        
                        if ImageResponse != nil {
                        
                                self.errorNetworkView.alpha = 0
                                cell.posterImage.alpha = 0
                                cell.posterImage.image = Image;
                        
                                UIView.animate(withDuration: 0.4, animations: {
                            
                                    cell.posterImage.alpha = 1
                            
                                })
                        } else {
                            
                            cell.posterImage.image = Image
                            
                        }
                        
                        
                    }, failure: { (request, response, error) in
                        
                        //cell.posterImage.image = UIImage(named: "")
                        UIView.animate(withDuration: 1.0, animations: {
                            self.errorNetworkView.alpha = 1
                        })
                        
                    })

                
         
        
        
        
        
            
            
            /*
            cell.posterImage.alpha = 0
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterImage.setImageWith(imageUrl!)
            UIView.animate(withDuration: 0.4, animations: {
                cell.posterImage.alpha = 1
            })
             */
            
        }

        
        
        print ("row \(indexPath.row)")
        
        
        return cell
    }
    
 
    
    
    
// COLLECTIONVIEW CONFIG ------------------------------------------------------------------
    
    //Cell size (autolayout)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3.01, height: self.view.frame.size.width / 2)
        return size
        
    }

    
    // cell numb
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }



    // cell config
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        
        // create imageView in cell to show pictures
        //let posterImage = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        //cell.addSubview(posterImage)
        
        // LOAD IMAGES
        
        let movie = filteredMovies![indexPath.row]
        let ImageUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let ImageRequest = NSURLRequest(url: NSURL(string: ImageUrl + posterPath)! as URL)
            
            
            cell.posterImage.setImageWith(ImageRequest as URLRequest, placeholderImage: nil, success: { (ImageRequest, ImageResponse, Image) in
                
                
                
                if ImageResponse != nil {
                    
                    self.errorNetworkView.alpha = 0
                     cell.posterImage.alpha = 0
                     cell.posterImage.image = Image;
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        
                         cell.posterImage.alpha = 1
                        
                    })
                } else {
                    
                     cell.posterImage.image = Image
                    
                }
                
                
            }, failure: { (request, response, error) in
                
                //cell.posterImage.image = UIImage(named: "")
                UIView.animate(withDuration: 1.0, animations: {
                    self.errorNetworkView.alpha = 1
                })
                
            })
        }

       
        
        
        return cell
        
}



    
    
    

    
// CONNECT TO API ------------------------------------------------------------------
    
    func connectToAPI() {
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
    let request = URLRequest(url: url)
    let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate:nil,
        delegateQueue:OperationQueue.main
    )
    
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.errorNetworkView.alpha = 0
        
    let task : URLSessionDataTask = session.dataTask(
        with: request as URLRequest,
        completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    
                    //print("responseDictionary: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    
                    
                    
                    //self.imageArray = [UIImage?](repeating: nil, count: (self.movies?.count)!)
                    
                
                    
                    self.refreshControl.endRefreshing()
                    self.refreshControlCollectionView.endRefreshing()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.reloadTableorCollection()
                    
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    //let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                }
            } else {
                
                print ("error connecting to API")
                MBProgressHUD.hide(for: self.view, animated: true)
                UIView.animate(withDuration: 1.0, animations: {
                    self.errorNetworkView.alpha = 1
                })
                
                
                
                
                
            }
    });
    task.resume()

    }
    

    
    
    
    
// REFRESH FUNCTIONS---------------------------------------------------------------------------
    
    func addRefresher() {
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshControlCollectionView = UIRefreshControl()
        refreshControlCollectionView.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControlCollectionView, at: 0)
        
            
        
            
        
        
        

    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        connectToAPI()
        
        searchBar.text = ""

    }
    
    
    
    
    
// SEARCHBAR FUNCTIONS---------------------------------------------------------------------------
    
    func searchButtonOn() {
      
        let searchIcon = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addSearchBar))
        
        if isSearching {
            
            self.navigationItem.rightBarButtonItem = nil

        } else {
            
            self.navigationItem.rightBarButtonItem = searchIcon
            
        }
        
    }
    
    
    func addSearchBar() {
        isSearching = true
        self.navigationItem.rightBarButtonItem = nil
        
        searchBar.delegate = self
        searchBar.alpha = 0
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        searchBar.showsCancelButton = true
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        self.navigationItem.rightBarButtonItem = nil
        UIView.animate(withDuration: 0.7) {
            self.searchBar.alpha = 1
        }
        
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
         
            let title = movie["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive) != nil
            
            
        })
        
        reloadTableorCollection()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //searchBar.showsCancelButton = true
        isSearching = true
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.navigationItem.leftBarButtonItem = nil
        
 
        filteredMovies = movies
        reloadTableorCollection()
        isSearching = false
        searchButtonOn()
        
        
    }

 
    
    
    @IBAction func listGridControl(_ sender: Any) {
        
    
        if segmentControl.selectedSegmentIndex == 1 {
            
            isTableView = false
        } else {
            isTableView = true
        }
        
        connectToAPI()
    }
    
        
        func reloadTableorCollection() {
            
            if isTableView {
                
                tableView.isHidden = false
                collectionView.isHidden = true
                tableView.reloadData()
            } else {
                
                collectionView.isHidden = false
                tableView.isHidden = true
                collectionView.reloadData()
            }

            
        }
        
    
    
    
    
// SEGUE ------------------------------------------------------------------
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("prepare for segue")
        
                // Get the new view controller using segue.destinationViewController.
                // Pass the selected object to the new view controller.
                if let cell = sender as? UITableViewCell
                {
                    let indexPath = tableView.indexPath(for: cell)
                    let movie = movies![indexPath!.row]
                    
                    let detailViewController = segue.destination as! DetailViewController
                    
                    
                    // Pass the selected object to the new view controller.
                    
                    detailViewController.movie = movie
                }
                else if let cell = sender as? UICollectionViewCell
                {
                    let indexPath = collectionView.indexPath(for: cell)
                    let movie = movies![indexPath!.row]
                    
                    let detailViewController = segue.destination as! DetailViewController
                    
                    
                    // Pass the selected object to the new view controller.
                    
                    detailViewController.movie = movie                }
        }
        
        



    
}
