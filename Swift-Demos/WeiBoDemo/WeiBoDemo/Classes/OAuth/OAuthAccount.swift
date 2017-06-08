//
//  OAuthAccount.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/12.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class OAuthAccount: NSObject, NSCoding {

    var access_token: String?
    var expires_in: NSNumber?{
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in as! TimeInterval)
        }
    }
    var expires_date : Date?
    var uid: String?
    var name: String?
    var avatar_url: String?
    
    override init() {
        
    }
    
    init(dict: [String: AnyObject]) {
        //初始化的时候不调用didSet方法, 调用set方法赋值时才会调用
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "avatar_hd" {
            avatar_url = value as? String
        }
    }
    
    override var description: String {
        let properties = ["access_token", "expires_in", "uid", "name", "expires_date", "avatar_url"]
        let dict = self.dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
    
    class func userLogin() -> Bool {
        return  loadAcount() != nil
    }
    
    static var filePath = "userAccount.plist".cacheDir()
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: OAuthAccount.filePath)
    }
    
    static var account: OAuthAccount?
    class func loadAcount() -> OAuthAccount? {
        //1. 是否加载过
        if OAuthAccount.account != nil{
            return OAuthAccount.account
        }
        //2. 加载授权模型
        OAuthAccount.account = NSKeyedUnarchiver.unarchiveObject(withFile: OAuthAccount.filePath) as? OAuthAccount
        
        //3. 是否过期
        if OAuthAccount.account?.expires_date?.compare(Date()) == ComparisonResult.orderedAscending{
            return nil
        }
        
        return OAuthAccount.account
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_url, forKey: "avatar_url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        name = aDecoder.decodeObject(forKey: "name") as? String
        avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
    }
    
    
}
