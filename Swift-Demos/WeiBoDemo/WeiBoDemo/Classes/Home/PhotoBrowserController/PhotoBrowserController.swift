//
//  PhotoBrowserController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/17.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoBrowserController: UIViewController {

    var currentIndex: Int = 0
    var pictureURLs: [URL] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    init(currentIndex: Int, urls: [URL]) {
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = currentIndex
        self.pictureURLs = urls
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        print(currentIndex, pictureURLs)
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: 保存图片
    func saveBtnClick() {
        //获取当前显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems.last!
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        let image = cell.iconView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //        - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if error != nil {
            SVProgressHUD.showError(withStatus: "保存失败")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }else{
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
    }
    
    /// collection
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = screenSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let collectionView = UICollectionView(frame: CGRect.init(origin: CGPoint.zero, size: screenSize), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoCollectionCellIdentity)
        return collectionView
    }()
    
    ///
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(self.dismissSelf), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    ///
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(self.saveBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()

}

let photoCollectionCellIdentity = "photoCollectionCellIdentity"
extension PhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate, PhotoBrowserCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCollectionCellIdentity, for: indexPath) as! PhotoCell
        cell.imageUrl = pictureURLs[indexPath.row]
        cell.closeDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissSelf()
    }
    
    func photoBrowserClose(cell: PhotoCell) {
        dismissSelf()
    }
    
    func savePhoto() {
        saveBtnClick()
    }
}
