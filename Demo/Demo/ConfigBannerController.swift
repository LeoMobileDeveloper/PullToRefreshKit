//
//  ConfigDefaultBannerController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit
class ConfigBannerController: UIViewController {
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Banners"
        self.automaticallyAdjustsScrollViewInsets = false
        setUpViews()
        let left = DefaultRefreshLeft.left()
        left.setText("👉滑动关闭", mode: .scrollToAction)
        left.setText("松开关闭", mode: .releaseToAction)
        left.textLabel.textColor = UIColor.orange
        scrollView.configSideRefresh(with: left,container:self, at: .left) {
            self.navigationController?.popViewController(animated: true)
        };
        
        let right  = DefaultRefreshRight.right()
        right.setText("👈滑动关闭", mode: .scrollToAction)
        right.setText("松开关闭", mode: .releaseToAction)
        right.textLabel.textColor = UIColor.orange
        scrollView.configSideRefresh(with: right, container:self, at: .right) {
            self.navigationController?.popViewController(animated: true)
        };
    }
    
    func setUpViews(){
        view.backgroundColor = UIColor.white
        let screenWidth = UIScreen.main.bounds.size.width;
        let scrollheight = screenWidth / 8.0 * 5.0
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: scrollheight)
        scrollView.center = self.view.center
        self.view.addSubview(scrollView)
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: scrollheight))
        imageView1.image = UIImage(named: "banner1.jpg")
        scrollView.addSubview(imageView1)
        
        let imageView2 = UIImageView(frame:CGRect(x: screenWidth, y: 0, width: screenWidth, height: scrollheight))
        imageView2.image = UIImage(named: "banner2.jpg")
        scrollView.addSubview(imageView2)
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: screenWidth * 2, height: scrollheight)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 40)
        label.font = UIFont.systemFont(ofSize: 14)
        label.center  = CGPoint(x: scrollView.center.x, y: scrollView.center.y - scrollView.frame.width/2 - 20)
        label.text = "向左或向右滑动Banner"
        label.textAlignment = .center
        view.addSubview(label)
    }
}
