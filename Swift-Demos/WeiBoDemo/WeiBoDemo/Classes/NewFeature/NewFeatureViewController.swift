//
//  NewFeatureViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/12.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let pageCount = 4

class NewFeatureViewController: UICollectionViewController {

    private var layout: UICollectionViewFlowLayout = NewFeatureLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewFeatureCell
        cell.pageIndex = indexPath.row
        
        return cell
    }
    

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pageCount-1 {
            (cell as! NewFeatureCell).btnAnimaiton()
        }
    }
    
}


class NewFeatureCell: UICollectionViewCell {
    
    var pageIndex: Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(pageIndex!+1)")
            if pageIndex == pageCount-1 {
                btn.isHidden = false
            }else{
                btn.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnAnimaiton() {
        btn.transform = CGAffineTransform(scaleX: 0.00, y: 0.00)
        btn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.btn.transform = CGAffineTransform.identity
        }, completion: { (b) in
            self.btn.isUserInteractionEnabled = true
        })
    }
    
    func btnClick() {
        print("dsfsdfsd")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.red
        contentView.addSubview(iconView)
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        
        contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(NewFeatureCell.btnClick), for: UIControlEvents.touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-150)
        }
    }
    
    ///
    private lazy var iconView = UIImageView()
    
    /// 按钮
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), for: UIControlState.highlighted)
        btn.isHidden = true
        
        return btn
    }()
}

private class NewFeatureLayout: UICollectionViewFlowLayout {
    override func prepare() {
        self.itemSize = UIScreen.main.bounds.size
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
    }
}
