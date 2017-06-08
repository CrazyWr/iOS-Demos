//
//  HomeViewController.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/6.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class HomeViewController: BaseViewController {

    var dataSource: Array<Status> = []
    
    var page: Int = 1
    let limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin{
            visitorView?.setupInfo(isHome: true, imageName: "visitordiscover_feed_image_house", message: "关注一些人, 回到这里看看有什么惊喜")
            return
        }
        
        setupNav()
        
        notificationCenter.addObserver(self, selector: #selector(self.showPhotoBrowser(notification:)), name: NSNotification.Name(rawValue: NotifyShowPhotoBrowserController), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        
    }
    
    // MARK: 初始化导航条
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeViewController.rightItemClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle(self.title, for: UIControlState.normal)
        titleBtn.addTarget(self, action: #selector(titleBtn(btn:)), for: UIControlEvents.touchUpInside)
        navigationItem.titleView = titleBtn
        
        tableView.register(StatusTableViewCell.self, forCellReuseIdentifier: StatusTableVIewCellIdentitifier.NormalCell.rawValue)
        tableView.register(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableVIewCellIdentitifier.ForwardCell.rawValue)
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 刷新控件
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshData))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
    }
    
    func showPhotoBrowser(notification: NSNotification) {
        let userinfo = notification.userInfo
        if userinfo?["urls"] == nil {
            print("error:  userinfo[\"urls\"] nil")
            return
        }
        
        if userinfo?["index"] == nil {
            print("error:  userinfo[\"index\"] nil")
            return
        }
        
        let urls = userinfo!["urls"] as! [URL]
        let index = userinfo!["index"] as! Int
        
        let photoBrowser = PhotoBrowserController(currentIndex: index, urls: urls)
        present(photoBrowser, animated: true, completion: nil)
        
        print()
    }
    
    func titleBtn(btn:UIButton){
        btn.isSelected = !btn.isSelected
        
        //设置转场代理
        let popVc = PopoverViewController()
        popVc.transitioningDelegate = popAnimationManager
        
        //设置转场模式
        popVc.modalPresentationStyle = UIModalPresentationStyle.custom
        
        present(popVc, animated: true)

    }
    
    func leftItemClick() {
        print("left")
    }
    
    func rightItemClick() {
        let qrCodeVC = QRCodeViewController()
        let naVC = UINavigationController()
        naVC.addChildViewController(qrCodeVC)
        present(naVC, animated: true, completion: nil)
    }
    
    func refreshData() {
        page = 1
        loadData(page: page, limit: limit, more: false)
    }
    
    func loadMore() {
        page = page + 1
        loadData(page: page, limit: limit, more: true)
    }
    
    func loadData(page: Int, limit: Int, more: Bool) {
        Status.loadStatuses(page: page, limit: limit) { (statuses) in
            
            if more {
                if statuses == nil || statuses?.count == 0 {
                    SVProgressHUD.showInfo(withStatus: "没有更多数据了")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                    self.page = page - 1
                }else{
                    SVProgressHUD.showSuccess(withStatus: "加载完成")
                    self.dataSource = self.dataSource + statuses!
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }else{
                if statuses == nil || statuses?.count == 0 {
                    
                }else{
                    SVProgressHUD.showSuccess(withStatus: "刷新成功")
                    self.dataSource = statuses!
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    /// 转场动画管理者
    private lazy var popAnimationManager:PopoverAnimationManager = {
        let pa = PopoverAnimationManager()
        weak var weakSelf = self
        pa.endBlock = {
            let titleBtn = weakSelf?.navigationItem.titleView as! TitleButton
            titleBtn.isSelected = !titleBtn.isSelected
        }
        return pa
    }()
    
    deinit {
        notificationCenter.removeObserver(self, name: NSNotification.Name.init(rawValue: NotifyShowPhotoBrowserController), object: nil)
    }
    
}

// MARK: UITableViewDataSource delegate
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableVIewCellIdentitifier.cellID(status: status), for: indexPath) as! StatusTableViewCell
        cell.status = status
        return cell
    }

}

