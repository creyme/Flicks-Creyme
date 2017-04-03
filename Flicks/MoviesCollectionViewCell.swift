//
//  MoviesCollectionViewCell.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 4/2/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    // DEFAULT FUNTION
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Alignment of image to UIImage view cell
        let width = UIScreen.main.bounds.width
        
        posterImage.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 2)
        
    }
    
}
