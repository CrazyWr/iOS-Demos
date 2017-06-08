//
//  MainViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/6.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        tabBar.tintColor = UIColor.orange
        
        //添加子控制器
        addChildViewControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpComposeBtn()
    }
    
    func composeBtnClick(){
//        print(#function)
        self.selectedIndex = 2
        
    }
    
    private func setUpComposeBtn(){
        let btn = composeBtn()
        tabBar.addSubview(btn)
        
        let width = UIScreen.main.bounds.width/5.0
        btn.frame = CGRect(x: 2*width, y: 5, width: width, height: 44.0)
        
    }
    
    private func addChildViewControllers() {
        let path = Bundle.main.path(forResource: "MainVCSettings", ofType: ".json")
        if path != nil {
            let jsonData = NSData(contentsOfFile: path!)
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                for item in jsonArray as! [[String: String]]{
                    self.addChildViewController(item["vcName"]!, item["title"]!, item["imageName"]!)
                }
            } catch {
                print(error)
                
                //从本地加载控制器
                self.addChildViewController("HomeViewController", "首页", "tabbar_home")
                self.addChildViewController("MessageViewController", "消息", "tabbar_message_center")
                self.addChildViewController("ComposeViewController", "", "")
                self.addChildViewController("DiscoverViewController", "发现", "tabbar_discover")
                self.addChildViewController("ProfileViewController", "我的", "tabbar_profile")
            }
        }

    }
    
    private func addChildViewController(_ className: String, _ title: String, _ imageName: String) {
        
        //动态获取命名空间
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String //!代表字典里面一定有值
        //默认情况下命名空间就是项目的名称, 但是命名空间是可以修改的 
        //字符串  ->  class
        let cls:AnyClass? = NSClassFromString(ns + "." + className)
        //class  创建类
        let vcCls = cls as! UIViewController.Type
        let childController = vcCls.init()
        
        childController.title = title
        childController.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        
        let nv = UINavigationController()
        nv.addChildViewController(childController)
        
        addChildViewController(nv)
    }

    //MARK: 懒加载
    private lazy var composeBtn = { () -> UIButton in 
        let btn = UIButton.init()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlight"), for: UIControlState.highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        
        //监听方法不能是私有方法
        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }
    
}
