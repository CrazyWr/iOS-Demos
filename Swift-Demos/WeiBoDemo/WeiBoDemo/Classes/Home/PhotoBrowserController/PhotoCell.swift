//
//  PhotoCell.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/17.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import FLAnimatedImage

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    func photoBrowserClose(cell: PhotoCell)
    func savePhoto()
}

class PhotoCell: UICollectionViewCell {
    
    weak var closeDelegate: PhotoBrowserCellDelegate?
    
    var imageUrl: URL? {
        didSet{
            print(imageUrl)
            //重置属性
            self.resetScrollView()
            
            //显示菊花
//            self.activityAnamation.startAnimating()
            
            self.iconView.sd_setImage(with: self.imageUrl, placeholderImage: UIImage(named: ""), options: []) { (image, error, _, _) in
                
                if image != nil {
                    let scale = (image?.size.height)!/(image?.size.width)!
                    let height = scale * self.contentView.frame.size.width
                    if height <= self.contentView.frame.size.height {
                        // 短图
                        self.iconView.frame = CGRect(x: 0, y: 0.5 * (self.contentView.frame.size.height - height), width: self.contentView.frame.size.width, height: height)
                        self.scrollView.contentSize = self.contentView.frame.size
                    }else{
                        // 长图
                        self.iconView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: height)
                        self.scrollView.contentSize = CGSize(width: self.contentView.frame.size.width, height: height)
                    }
                    
//                    self.activityAnamation.stopAnimating()
                }else{
                    SVProgressHUD.showError(withStatus: "网络出错!")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.black
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(iconView)
        iconView.center = scrollView.center
        iconView.isUserInteractionEnabled = true
//        contentView.addSubview(activityAnamation)
//        activityAnamation.center = contentView.center
    }
    
    func dismissPhotoBrowser() {
        self.closeDelegate?.photoBrowserClose(cell: self)
    }
    
    func savePhoto() {
        self.closeDelegate?.savePhoto()
    }
    
    // 防止重用时bug
    private func resetScrollView() {
        //重置scrollView
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
        
        //重置imageView
        iconView.transform = CGAffineTransform.identity
    }
    
    ///
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.dismissPhotoBrowser))
        scrollView.addGestureRecognizer(tapGR)
        
        return scrollView
    }()
    
    ///
    lazy var iconView: FLAnimatedImageView = {
        let view = FLAnimatedImageView(image: UIImage(named: ""))
        view.sd_setShowActivityIndicatorView(true)
        view.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.whiteLarge)
        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(self.savePhoto))
        view.addGestureRecognizer(longGR)
        return view
    }()
    
    ///
//    private lazy var activityAnamation: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
//        
//        return view
//    }()
    
}

extension PhotoCell: UIScrollViewDelegate {
    //返回 缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    
    //缩放结束  处理位置
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var offsetX = (screenWidth - (view?.frame.size.width)!) * 0.5
        var offsetY = (screenHeight - (view?.frame.size.height)!) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        iconView.frame.origin.y = 0
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)

    }
}
