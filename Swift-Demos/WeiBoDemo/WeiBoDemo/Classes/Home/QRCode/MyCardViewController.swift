//
//  MyCardViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/10.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class MyCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNV()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImageView()
        imageView.image = createaQRCode(text: "fhskjfhsjhfkashjdkfhksfhjsdhkf")
    }
    
    private func setupNV() {
        title = "我的名片"
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(view.snp.width).multipliedBy(250/375.0)
        }
        view.layoutIfNeeded()
    }
    
    /// 生成二维码
    ///
    /// - Parameter text:
    /// - Returns: 
    private func createaQRCode(text: String) -> UIImage {
        //1. 创建QR滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2. 设置默认属性 必须
        filter?.setDefaults()
        //3. 设置数据
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //4. 从滤镜中取出生成的图片
        let ciImage = filter?.outputImage
        let scale = imageView.frame.size.width / ciImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = filter!.outputImage!.applying(transform)

        return composePics(bgImage: UIImage(ciImage: transformImage), iconImage: UIImage(named: "preview_like_icon")!)
    }
    
    
    /// 合成图片
    ///
    /// - Parameters:
    ///   - bgImage:
    ///   - iconImage:
    /// - Returns:
    private func composePics(bgImage: UIImage, iconImage: UIImage) -> UIImage {
        //1. 获取上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //2. 绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        //3. 绘制icon
        let width: CGFloat = 50.0
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - width) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: width))
        //4. 合成图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //5. 关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: 懒加载
    ///
    private lazy var imageView: UIImageView = UIImageView()

}
