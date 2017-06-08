//
//  VisitorView.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SnapKit

//swift 协议 必须遵守NSObjectProtocol
protocol VisitorViewDelegate: NSObjectProtocol{
    /// 登录回调
    func loginBtnWillClick()
    
    /// 注册回调
    func registBtnWillClick()
}

class VisitorView: UIView {
    
    // 登录, 注册按钮 代理  weak 避免循环信用
    weak var delegate: VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(bgImage)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginBtn)
        addSubview(registBtn)
        
        bgImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        homeIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImage.snp.bottom)
            make.centerX.equalTo(homeIcon)
            make.width.equalTo(self).multipliedBy(224/375.0)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.left.equalTo(messageLabel.snp.left)
            make.width.equalTo(messageLabel.snp.width).multipliedBy(0.4)
        }
        
        registBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn)
            make.width.equalTo(loginBtn)
            make.right.equalTo(messageLabel)
        }
        
        maskBGView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loginBtnClick() {
        delegate?.loginBtnWillClick()
    }

    func registBtnClick() {
        delegate?.registBtnWillClick()
    }
    
    func setupInfo(isHome: Bool, imageName: String, message: String) {
        bgImage.isHidden = !isHome
        homeIcon.image = UIImage(named: imageName)
        messageLabel.text = message
        
        if isHome{
            startAnimation()
        }
    }
    
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2*Double.pi
        anim.duration = 10
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        
        bgImage.layer.add(anim, forKey: "anim")
    }
    
    // MARK: 懒加载控件
    /// 图标
    private lazy var homeIcon: UIImageView = {
        let homeIcon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return homeIcon
    }()
    /// 转盘背景
    private lazy var bgImage: UIImageView = {
        let bgImage = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return bgImage
    }()
    /// 信息label
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "fdsfdsfsdfsdfsdhjkfdhiuangfjkfhuhfkjfjkghdfughdfkgjdhgurhekjghdsugherkhgkjdhu"
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    /// 登录
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    /// 注册
    private lazy var registBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn.setTitle("注册", for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState.normal)
         btn.addTarget(self, action: #selector(VisitorView.registBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    /// 蒙版
    private lazy var maskBGView: UIImageView = {
        let maskBGView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return maskBGView
    }()
    

}
