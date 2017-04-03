//
//  CAGradientLayer-templates.swift
//  Flicks
//
//  Created by CRISTINA MACARAIG on 4/2/17.
//  Copyright © 2017 creyme. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func blackBottom() -> CAGradientLayer {
        let topColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0)
        let bottomColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 0.25]
        
        
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        //gradientLayer.startPoint = CGPoint(x: 0.25, y: 1.0)
        //gradientLayer.endPoint = CGPoint(x: 0.50, y: 0.0)
        
        return gradientLayer
    }
    
    func blackTop() -> CAGradientLayer {
        let topColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        let bottomColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        //gradientLayer.startPoint = CGPoint(x: 0.25, y: 1.0)
        //gradientLayer.endPoint = CGPoint(x: 0.50, y: 0.0)
        
        return gradientLayer
    }
    
    
}
