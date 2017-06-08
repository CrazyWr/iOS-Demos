//
//  TitleButton.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControlState.selected)
        sizeToFit()
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        titleLabel?.frame.offsetBy(dx: -(imageView?.frame.size.width)!, dy: 0)
//        imageView?.frame.offsetBy(dx: (titleLabel?.frame.size.width)!, dy: 100)

        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)!+5.0
    }

}
