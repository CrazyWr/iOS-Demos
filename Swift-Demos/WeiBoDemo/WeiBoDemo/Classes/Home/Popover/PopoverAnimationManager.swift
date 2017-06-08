//
//  PopoverAnimationManager.swift
//  WeiBoDemo
//  将转场动画的协议代码提出通过统一的类管理
//
//  Created by wei on 2017/4/10.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class PopoverAnimationManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var isPresent: Bool = false
    //结束动画执行的block
    var endBlock: (()->())?
    
    //实现代理方法, 告诉系统谁来负责转场动画
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
    
    /// 展现动画
    ///
    /// - Parameters:
    ///   - presented: <#presented description#>
    ///   - presenting: <#presenting description#>
    ///   - source: <#source description#>
    /// - Returns: <#return value description#>
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        return self
    }
    
    /// 消失动画
    ///
    /// - Parameter dismissed: <#dismissed description#>
    /// - Returns: <#return value description#>
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        return self
    }
    
    
    /// 动画时长
    ///
    /// - Parameter transitionContext: <#transitionContext description#>
    /// - Returns: <#return value description#>
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 4.0
    }
    
    
    /// how 动画
    ///
    /// - Parameter transitionContext: <#transitionContext description#>
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if isPresent{
            //1. 拿到展现视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            //        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            //            toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            toView.transform = CGAffineTransform(a: 1.0, b: 0, c: 0, d: 0.01, tx: 0, ty: 0)
            //注意:  一定要将视图添加到容器上
            transitionContext.containerView.addSubview(toView)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            toView.frame.origin.y = 0
            
            //2. 执行动画
            UIView.animate(withDuration: 0.5, animations: {
                //2.1 清空transform
                toView.transform = CGAffineTransform.identity
            }, completion: { (_) in
                ////2.2 动画执行完毕, 告知系统, 不写会出现未知错误
                transitionContext.completeTransition(true)
            })
        }else{
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            
            UIView.animate(withDuration: 0.2, animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
                //                toView.transform = CGAffineTransform(a: 0.01, b: 0, c: 0, d: 0.01, tx: 0, ty: 0)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
                
                self.endBlock!()
            })
        }
        
    }

    
}
