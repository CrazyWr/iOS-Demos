//
//  User.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/13.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: NSNumber?
    var name: String?
    /// 头像
    var avatar_hd: String? {
        didSet{
            avatar_url = URL(string: avatar_hd!)
        }
    }
    /// 头像URL
    var avatar_url: URL?
    /// 会员
    var mbtype: NSNumber?
    /// 会员等级
    var mbrank: NSNumber = 0{
        didSet{
            let rank = self.mbrank.intValue
            if  rank == 0 || rank > 7 {
                self.mbImage = nil
            }else{
                self.mbImage = UIImage(named: "common_icon_membership_level\(rank)")
            }
        }
    }
    /// 会员图片
    var mbImage: UIImage?
    /// 认证
    var verified: Bool?
    /// 认证类型 -1: 没有认证 0: 认证用户, 2,3,5: 企业认证, 220: 达人
    var verified_type: NSNumber = -1 {
        didSet{
            switch verified_type.intValue{
                case -1:
                    verified_image =  UIImage(named: "")
                
                case 2,3,5:
                    verified_image = UIImage(named: "avatar_enterprise_vip")
                
                case 220:
                    self.verified_image = UIImage(named: "avatar_vip")
                
                default:
                    break
            }
        }
    }
    /// 认证图片
    var verified_image: UIImage?
    
    // 字典转模型
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "verified" {
            verified = value as? Bool
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override var description: String {
        let properties = ["name", "id", "avatar_hd", "verified_type"]
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
}
