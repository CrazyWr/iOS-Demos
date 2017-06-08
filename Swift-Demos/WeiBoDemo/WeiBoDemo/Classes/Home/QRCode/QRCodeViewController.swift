//
//  QRCodeViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/10.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    var qrBorderView: UIImageView!
    var scanImageView: UIImageView!
    let height = 250/375.0 * UIScreen.main.bounds.size.width
    let height2 = 150/375.0 * UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNVBar()
        setupTabBar()
        setupQRCodeView()
        startAnimation()
    }
    
    private func setupNVBar() {
        navigationController?.navigationBar.tintColor = UIColor.orange
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QRCodeViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QRCodeViewController.rightItemClick))
    }
    
    private func setupTabBar() {
        let tabbar = UITabBar()
        tabbar.barTintColor = UIColor.black
        tabbar.tintColor = UIColor.orange
        let leftItem = UITabBarItem(title: "二维码", image: UIImage(named:"qrcode_tabbar_icon_qrcode"), selectedImage: UIImage(named:"qrcode_tabbar_icon_qrcode_hightlighted"))
        leftItem.tag = 0
        let rightItem = UITabBarItem(title: "条形码", image: UIImage(named:"qrcode_tabbar_icon_barcode"), selectedImage: UIImage(named:"qrcode_tabbar_icon_barcode_hightlighted"))
        rightItem.tag = 1
        tabbar.setItems([leftItem, rightItem], animated:true)
        view.addSubview(tabbar)
        tabbar.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(64)
            make.width.equalToSuperview()
        }
        tabbar.selectedItem = tabbar.items![0]
        tabbar.delegate = self
    }
    
    private func setupQRCodeView() {
        qrBorderView = UIImageView(image: UIImage(named: "qrcode_border"))
        view.addSubview(qrBorderView)
        scanImageView = UIImageView(image: UIImage(named: "qrcode_scanline_qrcode"))
        qrBorderView.addSubview(scanImageView)
        qrBorderView.clipsToBounds = true
        
        qrBorderView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(height)
        }
        scanImageView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
     
        let btn = UIButton()
//        btn.setBackgroundImage(UIImage(named: ""), for: UIControlState.normal)
        btn.setTitle("我的名片", for: UIControlState.normal)
        btn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(myCardClick), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(qrBorderView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
    }
    
    fileprivate func startAnimation() {
        
        self.view.layoutIfNeeded()
        self.scanImageView.frame.origin.y = -self.qrBorderView.frame.size.height
        //重复刷新动画
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.repeat, animations: {
            self.scanImageView.frame.origin.y = 0
        }) { (_) in
        }
        
        //开始扫描
        scanManager.starScan()
        
    }
    
    func leftItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func rightItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func myCardClick() {
        navigationController?.pushViewController(MyCardViewController(), animated: true)
    }
    
    // MARK: 懒加载
    /// 扫描管理
    private lazy var scanManager:QRCodeScanManager = {
        let scanManager = QRCodeScanManager()
        scanManager.previewVC = self
        return scanManager
    }()
}

extension  QRCodeViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tag = tabBar.selectedItem?.tag
        switch tag! {
        case 0://二维码
            qrBorderView.snp.updateConstraints({ (make) in
                make.height.equalTo(height)
            })
            scanImageView.image = UIImage(named: "qrcode_scanline_qrcode")
        case 1://条形码
            qrBorderView.snp.updateConstraints({ (make) in
                make.height.equalTo(height2)
            })
            scanImageView.image = UIImage(named: "qrcode_scanline_barcode")
        default:
            break
        }
        self.view.layoutIfNeeded()
        scanImageView.layer.removeAllAnimations()
        startAnimation()
    }
}
