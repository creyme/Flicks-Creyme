//
//  DetailViewController.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 3/31/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    // OUTLETS
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var topOverlay: UIView!
    @IBOutlet weak var errorNetworkView: UIView!
    
    // VARIABLES
    var movie: NSDictionary!
    
    
// DEFAULT ---------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print (movie)
        
        
        // APPEARANCE
        self.errorNetworkView.alpha = 0

        
        topOverlay.backgroundColor = UIColor.clear
        let overlay = CAGradientLayer().blackTop()
        overlay.frame = topOverlay.bounds
        topOverlay.layer.insertSublayer(overlay, at: 1)
        
        
        
        //infoView.frame.size = CGSize(width: scrollView.frame.size.width, height: titleLabel.frame.size.height + overviewLabel.frame.size.height + 100)
        

        
        

        
        
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        infoView.frame.size = CGSize(width: view.frame.size.width, height: titleLabel.frame.size.height + overviewLabel.frame.size.height + 100)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        infoView.backgroundColor = UIColor.clear
        let background = CAGradientLayer().blackBottom()
        background.frame = infoView.bounds
        infoView.layer.insertSublayer(background, at: 0)

        
        
        
        // LOAD IMAGES
        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
        let largeImageUrl = "https://image.tmdb.org/t/p/original"
        
        if let posterPath = movie["poster_path"] as? String {
            
            let smallImageRequest = NSURLRequest(url: URL(string: smallImageUrl + posterPath)!) as URLRequest
            let largeImageRequest = NSURLRequest(url: URL(string: largeImageUrl + posterPath)!) as URLRequest
            
            posterImage.setImageWith(smallImageRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                
                self.errorNetworkView.alpha = 0
                self.posterImage.alpha = 0
                self.posterImage.image = smallImage;
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    self.posterImage.alpha = 1
                    
                }, completion: { (success) in
                    
                    self.posterImage.setImageWith(largeImageRequest, placeholderImage: nil, success: { (largeImageRequest, largeImageResponse, largeImage) in
                        
                        self.posterImage.image = largeImage;
                        
                    }, failure: { (request, response, error) in
                        
                        self.posterImage.image = smallImage
                    })
                    
                })
                
                
            }, failure: { (request, response, error) in
                
                //posterImage.image = UIImage(named: "")
                UIView.animate(withDuration: 1.0, animations: {
                    self.errorNetworkView.alpha = 1
                })
                
            })
        }

        
    }


}
