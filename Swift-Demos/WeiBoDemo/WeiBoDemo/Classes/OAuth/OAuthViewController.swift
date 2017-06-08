//
//  OAuthViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/11.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    let App_Key = "3656833625"
    let App_Secret = "4c79a95e8c8e402bbb8bc8030e33e50b"
    let redirect_url = "http://wmonkey.top"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissSelf))
    
        //1. 获取未授权的RequestToken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&response_type=code&redirect_uri=\(redirect_url)"
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
    }

    func dismissSelf() {
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    // MARK: 懒加载
    ///
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()

}

extension OAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        //        "https://api.weibo.com/oauth2/authorize?client_id=3656833625&response_type=code&redirect_uri=http://wmonkey.top")
        //        "https://api.weibo.com/oauth2/authorize")
        //        "https://api.weibo.com/oauth2/authorize#")
        //        "https://api.weibo.com/oauth2/authorize")
        //        "http://wmonkey.top/?code=20302dea19864397915ae39396d80367")

        let urlStr = request.url?.absoluteString
        if !(urlStr?.hasPrefix(redirect_url))!{
            return true
        }
        
        let codeStr = "code="
        if (request.url?.query?.hasPrefix(codeStr))!{
            //授权成功, 取出授权token
            let code = request.url!.query?.substring(from: codeStr.endIndex)
            loadAccessToken(code: code!)
//            print(code ?? "dd")
        }else{
            //取消授权
            self.dismissSelf()
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.showInfo(withStatus: "正在加载...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    private func loadAccessToken(code: String) {
        
        NetworkManager().getAccessToken(code: code) { (account, error) in
            if error != nil {
                
            }else{
                //保存用户信息
                account?.saveAccount()
                self.dismissSelf()
            }
        }
        
    }
    
}
