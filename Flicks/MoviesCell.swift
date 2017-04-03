//
//  MoviesCell.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 3/31/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    // OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
