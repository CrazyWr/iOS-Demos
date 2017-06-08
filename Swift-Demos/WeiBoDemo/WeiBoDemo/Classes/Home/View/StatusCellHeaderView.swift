//
//  StatusCellHeaderView.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/14.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class StatusCellHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.left.top.equalToSuperview().offset(15)
        }
        
        iconView.addSubview(vertifyView)
        vertifyView.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.right.bottom.equalToSuperview().offset(10)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(iconView.snp.top)
        }
        
        addSubview(vipView)
        vipView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
        }
        
        addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(5)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
    }
    
    func setHeaderData(status: Status) {
        nameLabel.text = status.user?.name
        timeLabel.text = status.timeStr
        sourceLabel.text = status.sourceStr
        //头像
        iconView.sd_setImage(with:status.user?.avatar_url, placeholderImage:UIImage(named: "avatar_default"), options: [], completed:{ (image, error, SDImageCacheType, url) in
        })
        //认证图标
        vertifyView.image = status.user?.verified_image
        //会员图标
        vipView.image = status.user?.mbImage
    }
    
    /// 头像
    private lazy var iconView = UIImageView()
    
    /// 认证
    private lazy var vertifyView = UIImageView()
    
    /// nameLabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel.createLabel(text: "", color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), lineNumber: 1)
        return label
    }()
    
    /// 会员
    private lazy var vipView: UIImageView = {
        let  imageView = UIImageView()
        return imageView
    }()
    
    /// timeLabel
    private lazy var timeLabel: UILabel = {
        let label = UILabel.createLabel(text: "", color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), lineNumber: 1)
        return label
    }()
    
    /// sourceLabel
    private lazy var sourceLabel: UILabel = {
        let label = UILabel.createLabel(text: "", color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), lineNumber: 1)
        return label
    }()

}
