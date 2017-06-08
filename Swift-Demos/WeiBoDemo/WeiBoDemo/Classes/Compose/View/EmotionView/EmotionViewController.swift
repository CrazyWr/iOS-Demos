//
//  EmotionViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/18.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {

    var emotionDidSelectedCallBack: (_ emotion: Emotion)->()
    
    init(emotionCallBack: @escaping ((_ emotion: Emotion)->())) {
        self.emotionDidSelectedCallBack = emotionCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        setupUI()
        collectionView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        //布局
        
        //禁止 autresizing
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionView": collectionView, "toolBar": toolBar] as [String : Any]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }

    func itemClick(item: UIBarButtonItem) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: item.tag), at: UICollectionViewScrollPosition.left, animated: true)
        collectionView.reloadData()
    }
    
    /// toolBar
    private lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        tool.tintColor = UIColor.darkGray
        tool.backgroundColor = UIColor.purple
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近", "默认", "emoji", "浪小花"].enumerated() {
            let item = UIBarButtonItem(title: title.element, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.itemClick(item:)))
            item.tag = title.offset
            items.append(item)
            
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
            items.append(space)
        }
        items.removeLast()
        tool.items = items
        return tool
    }()
    
    /// collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.frame.size.width / 7
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.backgroundColor = UIColor.lightText
        
        collection.register(EmotionCell.self, forCellWithReuseIdentifier: emotionCollectionViewIdentity)
        return collection
    }()
    
    fileprivate lazy var packages: [EmotionPackage] = EmotionPackage.loadPackages()
    
}

let emotionCollectionViewIdentity = "emotionCollectionViewIdentity"
extension EmotionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    // 告诉系统每组有多少行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emotions?.count ?? 0
    }
    // 告诉系统每行显示什么内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCollectionViewIdentity, for: indexPath) as! EmotionCell
        
        // 1.取出对应的组
        let package = packages[indexPath.section]
        // 2.取出对应组对应行的模型
        let emoticon = package.emotions![indexPath.item]
        // 3.赋值给cell
        cell.emoticon = emoticon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let emotion = packages[indexPath.section].emotions?[indexPath.row]
        self.emotionDidSelectedCallBack(emotion!)
        //添加 最近表情
        if !(emotion?.isRemoveButton)! {
            packages[0].appendEmotion(emotion: emotion!)
        }
    }
}

private class EmotionCell: UICollectionViewCell {
    var emoticon: Emotion?
    {
        didSet{
            // 1.判断是否是图片表情
            if emoticon!.chs != nil{
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: UIControlState.normal)
            }else{
                // 防止重用
                iconButton.setImage(nil, for: UIControlState.normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            iconButton.setTitle(emoticon!.emojiStr ?? "", for: UIControlState.normal)
            
            // 3.判断是否是删除按钮
            if emoticon!.isRemoveButton{
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
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
    
    private func setupUI() {
        contentView.addSubview(iconButton)
//        contentView.backgroundColor = UIColor.white
    }
    
    /// iconBtn
    private lazy var iconButton: UIButton = {
        let btn = UIButton(frame: self.contentView.bounds)
        btn.frame = btn.frame.insetBy(dx: 1.0, dy: 1.0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.white
        return btn
    }()
}
