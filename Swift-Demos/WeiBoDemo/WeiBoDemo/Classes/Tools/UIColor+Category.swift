//
//  UIColor+Category.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/17.
//  Copyright © 2017年 wei. All rights reserved.
//

import Foundation

extension UIColor{
    class func randomColor() -> UIColor{
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber(), alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat{
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}

