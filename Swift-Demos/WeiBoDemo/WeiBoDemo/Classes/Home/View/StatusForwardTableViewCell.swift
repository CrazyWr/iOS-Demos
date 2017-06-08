//
//  StatusForwardTableViewCell.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/14.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit


class StatusForwardTableViewCell: StatusTableViewCell {

    // 不会覆盖父类的didSet
    // 父类是didSet, 子类只能复写didSet  willSet...不能复写
    override var status: Status?{
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLable.text = name + text
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(forwardBg, belowSubview: pictureView)
        forwardBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(topMargin)
            make.bottom.equalTo(pictureView.snp.bottom).offset(topMargin)
        }
        
        forwardBg.addSubview(forwardLable)
        forwardLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(-leftMargin)
            make.top.equalToSuperview().offset(topMargin)
        }
        
        pictureView.snp.remakeConstraints { (make) in
            make.top.equalTo(forwardLable.snp.bottom).offset(topMargin)
            make.left.equalTo(forwardBg.snp.left).offset(topMargin)
            make.width.height.equalTo(0)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(forwardBg.snp.bottom)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
    ///
    private lazy var forwardLable: UILabel = {
        let label = UILabel.createLabel(text: "", color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 15), lineNumber: 0)
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-40
        return label
    }()
    
    ///
    private lazy var forwardBg: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        return btn
    }()

}
