//
//  navViewController.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 4/2/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit

class navViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize Appearance
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationBar.tintColor = .white
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barStyle = .black
        self.navigationBar.isTranslucent = true
        

    }

   
}
