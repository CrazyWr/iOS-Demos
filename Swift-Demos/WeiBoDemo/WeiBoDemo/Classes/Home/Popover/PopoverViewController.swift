
//
//  PopoverViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SnapKit

class PopoverViewController: UIViewController {

    var bgImageView: UIImageView!
    var tableView: UITableView!
    var maskBgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBgMaskView()
        setupBgImage()
        setupTableview()
        
    }
    
    private func setupBgMaskView() {
        maskBgView = UIView(frame: self.view.bounds)
        maskBgView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        self.view.addSubview(maskBgView)
        
        //点击手势
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(PopoverViewController.dismissSelf))
        maskBgView.addGestureRecognizer(tapGR)
        
    }
    
    private func setupBgImage() {
        let bgImage = UIImage(named: "popover_background")
        bgImageView = UIImageView()
        bgImageView.image = bgImage
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(bgImageView.snp.width).multipliedBy(1.2)
        }
    }
    
    private func setupTableview() {
        tableView = UITableView(frame: bgImageView.bounds, style: UITableViewStyle.plain)
        bgImageView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func dismissSelf() {
        self.dismiss(animated: true) {
            
        }
    }
    
}
