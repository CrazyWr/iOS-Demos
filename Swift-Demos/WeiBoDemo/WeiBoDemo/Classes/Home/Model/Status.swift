//
//  Status.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/13.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    var id: NSNumber?
    /// 创建时间
    var created_at: String? {
        didSet{
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US")
//            dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d HH:mm:ss Z yyyy")
//            let date = NSDate(from: created_at, withFormat: "EEE MMM d HH:mm:ss Z yyyy")
//            let date = Date()
//            print()
//            timeStr = date?.ff_dateDescription()
        }
    }
    /// 时间转换字符串
    var timeStr: String? = "刚刚"
    /// 内容
    var text: String?
    /// 原始来源
    var source: String? {
        didSet{
            //"<a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>"

            let pattern = "\\>(.*)\\<"
            let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
            let results = regular.matches(in: self.source!, options: .withoutAnchoringBounds , range: NSMakeRange(0, self.source!.characters.count))
            let range = (results.last)?.range ?? nil
            if range == nil{
                sourceStr = ""
            }else{
                sourceStr = (source! as NSString).substring(with: NSMakeRange((range?.location)!+1, (range?.length)!-2))
            }
        }
    }
    /// 来源字符串
    var sourceStr: String?
    /// 图片路径数组
    var pic_urls: [[String: AnyObject]]? {
        didSet{
            for dict in pic_urls! {
                let path = dict["thumbnail_pic"] as! String
                image_urls.append(URL(string: path)!)
                bigImage_urls.append(URL(string: path.replacingOccurrences(of: "thumbnail", with: "large"))!)
            }
        }
    }
    /// 配图URL数组
    private var image_urls: [URL] = []
    /// 大图URL数组
    private var bigImage_urls: [URL] = []
    /// 用户信息
    var user: User?
    /// 转发信息
    var retweeted_status: Status?
    
    /// 加载微博数据
    class func loadStatuses(page: Int, limit: Int, finished: @escaping (_ statuses: [Status]?)->()){
        NetworkManager.sharedManager().getWeiBoStatusData(page: page, count: limit) { (array, error) in
            if error == nil{
                cacheImageData(list: array)
                finished(array)
            }else{
                finished(nil)
            }
        }
    }
    
    /// 缓存配图
    class func cacheImageData(list: [Status]?) {
        for status in list! {
            for url in status.getImage_urls(){
                SDWebImageManager().loadImage(with: url, options: [], progress: nil, completed: { (image, data, error, _, _, url) in
                    
                })
            }
        }
    }
    
    func getImage_urls() -> [URL]{
        if retweeted_status != nil {
            return retweeted_status!.image_urls
        }else{
            return image_urls
        }
    }
    
    func getBigImage_urls() -> [URL]{
        if retweeted_status != nil {
            return retweeted_status!.bigImage_urls
        }else{
            return bigImage_urls
        }
    }
    
    // 字典转模型
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            user = User(dict: value as! [String: Any])
            return
        }
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String: Any])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String {
        let properties = ["created_at", "id", "text", "source", "pic_urls", "user"]
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
    
}
