//
//  UIButton+Category.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/13.
//  Copyright © 2017年 wei. All rights reserved.
//

import Foundation

extension UIButton{
    //class func 类方法 OC 中的+
    class open func create(title: String?, titleColor: UIColor?, titleFont: UIFont?, imageName: String?, backgroundImageName: String?, titleEdgeInsets: UIEdgeInsets?) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName!), for: UIControlState.normal)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setTitleColor(titleColor, for: UIControlState.normal)
        btn.titleLabel?.font = titleFont!
        btn.setBackgroundImage(UIImage(named: backgroundImageName!), for: UIControlState.normal)
        btn.titleEdgeInsets = titleEdgeInsets!
        return btn
    }
}
