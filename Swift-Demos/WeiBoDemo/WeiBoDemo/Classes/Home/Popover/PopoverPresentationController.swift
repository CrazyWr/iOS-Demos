//
//  PopoverPresentationController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/7.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    ///  初始化防范, 用于创建负责转场动画的对象
    ///
    /// - Parameters:
    ///   - presentedViewController: 被展现的控制器
    ///   - presentingViewController: 发起的控制器
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        
    }
    
    
    /// 即将布局转场子视图是调用
    override func containerViewWillLayoutSubviews() {
        //修改弹出视图的大小
//        presentedView?.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        //修改内容视图的大小
    }
    
}
