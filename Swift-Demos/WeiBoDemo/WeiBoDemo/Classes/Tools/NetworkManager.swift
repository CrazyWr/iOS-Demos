//
//  NetworkManager.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/11.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NetworkManager: NSObject {

    let baseurl = "https://api.weibo.com/"
    let App_Key = "3656833625"
    let App_Secret = "4c79a95e8c8e402bbb8bc8030e33e50b"
    let redirect_url = "http://wmonkey.top"

    static private let manager: SessionManager = {
        let manager = NetworkManager()
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5
        return SessionManager(configuration: configuration)
    }()
    
    static private let networkManager = NetworkManager()
    class func sharedManager() -> NetworkManager {
        return self.networkManager
    }
    
    func getAccessToken(code: String, finished: @escaping (_ data: OAuthAccount?, _ error: Error?)->()) {
        
        let path = "oauth2/access_token"
        
        let params = ["client_id": App_Key,
                      "client_secret": App_Secret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": redirect_url]
        
        NetworkManager.manager.request(baseurl+path, method: Alamofire.HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.error != nil{
                print(response.error!)
                self.showInternetError()
                finished(nil, response.error!)
            }else{
                let account = OAuthAccount.init(dict: response.result.value as! [String: AnyObject])
                self.getUserInfo(account: account, finished: { (account, error) in
                    
                    finished(account, nil)
                })
            }
        }
        
    }
    
    func getUserInfo(account: OAuthAccount, finished: @escaping (_ data: OAuthAccount?, _ error: Error?)->()) {
        let path = "2/users/show.json"
        let params = ["access_token": account.access_token!,
                      "uid": account.uid!]
         NetworkManager.manager.request(baseurl+path, method: Alamofire.HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.error != nil{
                print(response.error!)
                self.showInternetError()
                finished(nil, response.error!)
            }else{
                account.setValuesForKeys(response.result.value as! [String: AnyObject])
                finished(account, nil)
            }
        }
    }
    
    func getWeiBoStatusData(page: Int?, count: Int?, finished: @escaping (_ data: Array<Status>?, _ error: Error?)->()) {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": OAuthAccount.loadAcount()!.access_token!,
                      "page": page ?? 1,
                      "count": count ?? 20,
                      ] as [String : Any]
         NetworkManager.manager.request(baseurl+path, method: Alamofire.HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.error != nil{
                print(response.error!)
                self.showInternetError()
                finished(nil, response.error!)
            }else{
                
                let statuses = (response.result.value as! [String: Any])["statuses"] as! Array<Any>
                var data: Array<Status> = []
                for item in statuses {
                    let status = Status(dict: item as! [String: AnyObject])
                    data.append(status)
                }
                
                finished(data, nil)
            }
        }
    }
    
    func postTextStatus(status: String, finished: @escaping ( _ error: Error?)->()) {
        let path = "2/statuses/update.json"
        let params = ["access_token": OAuthAccount.loadAcount()!.access_token!,
                      "status": status
                      ] as [String : Any]
        
         NetworkManager.manager.request(baseurl+path, method: Alamofire.HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.error != nil{
                print(response.error!)
                self.showInternetError()
                finished(response.error!)
            }else{
                
                let result = (response.result.value as! [String: Any])
                print(result)
                finished(nil)
            }
        }
    }
    
    private func showInternetError() {
        SVProgressHUD.showError(withStatus: "网络异常, 请重试")
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    
}
