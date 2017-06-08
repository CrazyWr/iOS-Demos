
//
//  BaseViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController, VisitorViewDelegate {

    var isLogin: Bool {
        get{
             return OAuthAccount.userLogin()
        }
    }
    var visitorView: VisitorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    
    func setUpVisitorView() {
        visitorView = VisitorView()
        view = visitorView
        visitorView?.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.orange
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.loginBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.registBtnWillClick))
    }

    // MARK: visitorViewDelegate
    func loginBtnWillClick() {
        let oauth = OAuthViewController()
        let nv = UINavigationController(rootViewController: oauth)
        present(nv, animated: true, completion: nil)
    }
    
    func registBtnWillClick() {
        print(#function)
        
    }
    
    
}
