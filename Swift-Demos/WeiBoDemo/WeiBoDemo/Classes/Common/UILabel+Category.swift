//
//  UILabel+Category.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/13.
//  Copyright © 2017年 wei. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    //class func 类方法 OC 中的+
    class open func createLabel(text: String?, color: UIColor?, font: UIFont?, lineNumber: Int?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.numberOfLines = lineNumber!
        label.sizeToFit()
        
        return label
    }
}
