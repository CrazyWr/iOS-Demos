//
//  StatusTableViewCell.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/13.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

let leftMargin = 15.0
let topMargin = 10.0

enum StatusTableVIewCellIdentitifier: String {
    case NormalCell = "StatusTableViewCellIdentity"
    case ForwardCell = "StatusForwardTableViewCellIdentity"
    static func cellID(status: Status) -> String {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    
    var status: Status? {
        didSet{
            headerView.setHeaderData(status: status!)
            contentLabel.text = status?.text
            pictureView.status = status
            //图片视图尺寸
            let size = pictureView.calculateImagesViewSize().viewSize
            pictureView.snp.updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftMargin)
            make.top.equalTo(headerView.snp.bottom).offset(0)
            make.width.equalToSuperview().offset(-30)
        }
        
        contentView.addSubview(pictureView)
        pictureView.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(topMargin)
            make.width.height.equalTo(0)
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(pictureView.snp.bottom).offset(topMargin)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
    /// 头部视图
    private lazy var headerView: StatusCellHeaderView = StatusCellHeaderView()
    
    /// 正文
    lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(text: "", color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), lineNumber: 0)
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-30
        return label
    }()
    
    /// 配图
    lazy var pictureView: StatusCellPicturesView = StatusCellPicturesView()
    
    /// 底部视图
    lazy var bottomView: StatusCellBottomBarView = StatusCellBottomBarView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


