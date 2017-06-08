//
//  StatusCellBottomBarView.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/14.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class StatusCellBottomBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        addSubview(self.retweetBtn)
        addSubview(self.alockBtn)
        addSubview(self.commentBtn)
        addSubview(self.retweetBtn)
        self.retweetBtn.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/3.0)
            make.height.equalToSuperview().offset(-4)
        }
        
        addSubview(self.alockBtn)
        self.alockBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.retweetBtn)
            make.left.equalTo(self.retweetBtn.snp.right)
            make.width.height.equalTo(self.retweetBtn)
        }
        
        addSubview(self.commentBtn)
        self.commentBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.retweetBtn)
            make.left.equalTo(self.alockBtn.snp.right)
            make.width.height.equalTo(self.retweetBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton.create(title: "转发", titleColor: UIColor.darkGray, titleFont: UIFont.systemFont(ofSize: 14), imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background", titleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0))
        return btn
    }()
    
    private lazy var alockBtn: UIButton = {
        let btn = UIButton.create(title: "赞", titleColor: UIColor.darkGray, titleFont: UIFont.systemFont(ofSize: 14), imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background", titleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0))
        return btn
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = UIButton.create(title: "评论", titleColor: UIColor.darkGray, titleFont: UIFont.systemFont(ofSize: 14), imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background", titleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0))
        return btn
    }()

}
