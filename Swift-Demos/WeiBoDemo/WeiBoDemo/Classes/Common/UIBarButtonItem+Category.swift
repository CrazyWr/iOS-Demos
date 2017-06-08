//
//  UIBarButtonItem+Category.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    //class func 类方法 OC 中的+
    class open func createBarButtonItem(imageName: String, target: AnyObject?, action:Selector) -> UIBarButtonItem {
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        leftBtn.setImage(UIImage(named: imageName+"_highlighted"), for: UIControlState.highlighted)
        leftBtn.sizeToFit()
        leftBtn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: leftBtn)
    }
}
