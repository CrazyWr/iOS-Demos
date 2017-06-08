//
//  ComposeViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/18.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNV()
        self.setupInputView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNV() {
        navigationController?.navigationBar.tintColor = UIColor.orange
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.sendTextStatus))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let titleLabel = UILabel()
        titleLabel.text = "发微博"
        view.addSubview(titleLabel)
        let nameLabel = UILabel()
        nameLabel.text = OAuthAccount.account?.name
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(nameLabel)
        navigationItem.titleView = view
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupInputView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
        }
        textView.becomeFirstResponder()
    }
    
    func dismissSelf() {
        tabBarController?.selectedIndex = 0
    }
    
    /// 发送文本微博
    func sendTextStatus() {
        
        var strM = String()
        self.textView.attributedText.enumerateAttributes(in: NSMakeRange(0, self.textView.attributedText.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (dict, range, _) in

            let attachment = dict["NSAttrachment"]
            if attachment != nil {
                //图片
                strM += (attachment as! EmotionAttachment).chs!
            }else{
                //文字
                strM += (self.textView.text! as NSString).substring(with: range)
            }
        }
        print(strM)
        
        NetworkManager.sharedManager().postTextStatus(status: strM) { (error) in
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "发送微博成功")
                SVProgressHUD.dismiss(withDelay: 1.5, completion: { 
                    self.dismissSelf()
                })
            }else{
                SVProgressHUD.showError(withStatus: "发送微博失败")
                SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                })
                print(error.debugDescription)
            }
        }
    }
    
    ///
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.inputView = self.emotionViewController.view
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.text = "网氛围 "
        return textView
    }()
    
    /// placeHolder
    fileprivate lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.isHidden = false
        return label
    }()

    /// EmotionViewController
    private lazy var emotionViewController: EmotionViewController = {
        
        //注意循环引用  weak修饰 self可选类型 释放会置为nil self要加!   unowned unsafe_unretain self不是可选类型 不用加!
        let emotionVC = EmotionViewController(emotionCallBack: { [unowned self] (emotion) in
            self.textView.insertEmotion(emotion: emotion)
        })
        return emotionVC
    }()
}

extension ComposeViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
         placeHolderLabel.isHidden = textView.hasText
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
         placeHolderLabel.isHidden = textView.hasText
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         placeHolderLabel.isHidden = textView.hasText
    }
}
