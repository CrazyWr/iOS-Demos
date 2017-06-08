//
//  StatusCellPicturesView.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/14.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

let collectionReuseIdentity: String = "picCellIdentity"
class StatusCellPicturesView: UICollectionView {
    
    var status: Status? {
        didSet{
            reloadData()
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        
        layout.minimumLineSpacing = 5.0
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clear
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.register(CollectionViewCell.self, forCellWithReuseIdentifier: collectionReuseIdentity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateImagesViewSize() -> (viewSize: CGSize, itemSize: CGSize){
        
        //1. 个数
        let count = status?.getImage_urls().count
        if count == 0 {
            return (CGSize.zero, CGSize.zero)
        }
        
        var viewSize = CGSize()
        var itemSize = CGSize()
        let width = 90.0
        let margin = 5.0
        
        switch count! {
        case 1:
            //返回图片实际尺寸
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: status?.getImage_urls().first?.absoluteString)
            guard (image != nil) else {
                return (CGSize.zero, CGSize.zero)
            }
            viewSize = (image?.size)!
            itemSize = viewSize
            
        case 4:
            let viewWidth = width*2 + margin
            viewSize.width = CGFloat(viewWidth)
            viewSize.height = CGFloat(viewWidth)
            itemSize = CGSize(width: width, height: width)
            break
        default:
            let colNumber = 3.0
            let rowNumber = ceil(Double(count!)/colNumber)
            viewSize.width = CGFloat(colNumber * width + (colNumber-1) * margin)
            viewSize.height = CGFloat(rowNumber * width + (rowNumber-1) * margin)
            itemSize = CGSize(width: width, height: width)
            break
        }
    
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = itemSize
        return (viewSize, itemSize)
    }
    
}

extension StatusCellPicturesView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (status?.getImage_urls().count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentity, for: indexPath) as! CollectionViewCell
        cell.setImageData(url: (status?.getImage_urls()[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        notificationCenter.post(name: NSNotification.Name.init(rawValue: NotifyShowPhotoBrowserController), object: self, userInfo: ["urls": status?.getBigImage_urls() as Any, "index": indexPath.row])
    }
}

private class CollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageData(url: URL) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        
        let path = url.absoluteString.lowercased()
        if path.hasSuffix("gif") {
            gifView.isHidden = false
        }else{
            gifView.isHidden = true
        }
        
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.red
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        
        contentView.addSubview(gifView)
        gifView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
    
    private lazy var imageView: FLAnimatedImageView = {
        let view = FLAnimatedImageView()
        view.sd_setShowActivityIndicatorView(true)
        view.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.whiteLarge)
        return view
    }()
    
    ///
    private lazy var gifView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightText
        label.tintColor = UIColor.darkGray
        label.text = "GIF"
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
