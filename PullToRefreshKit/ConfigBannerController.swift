//
//  ConfigDefaultBannerController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class ConfigBannerController: UIViewController {
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Banners"
        self.automaticallyAdjustsScrollViewInsets = false
        setUpViews()
        
        scrollView.setUpLeftRefresh { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }.SetUp { (left) in
            left.setText("👉滑动关闭", mode: RefreshKitLeftRightText.scrollToAction)
            left.setText("松开关闭", mode: RefreshKitLeftRightText.releaseToAction)
            left.textLabel.textColor = UIColor.orangeColor()
        }
        scrollView.setUpRightRefresh { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }.SetUp { (right) in
            right.setText("👈滑动关闭", mode: RefreshKitLeftRightText.scrollToAction)
            right.setText("松开关闭", mode: RefreshKitLeftRightText.releaseToAction)
            right.textLabel.textColor = UIColor.orangeColor()
        }
    }
    
    func setUpViews(){
        view.backgroundColor = UIColor.whiteColor()
        let screenWidth = UIScreen.mainScreen().bounds.size.width;
        let scrollheight = screenWidth / 8.0 * 5.0
        scrollView.frame = CGRectMake(0, 0, screenWidth, scrollheight)
        scrollView.center = self.view.center
        self.view.addSubview(scrollView)
        let imageView1 = UIImageView(frame:CGRectMake(0, 0, screenWidth, scrollheight))
        imageView1.image = UIImage(named: "banner1.jpg")
        scrollView.addSubview(imageView1)
        
        let imageView2 = UIImageView(frame:CGRectMake(screenWidth, 0, screenWidth, scrollheight))
        imageView2.image = UIImage(named: "banner2.jpg")
        scrollView.addSubview(imageView2)
        
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollheight)
        let desLabel = UILabel().SetUp { (label) in
            label.frame = CGRectMake(0, 0, screenWidth, 40)
            label.font = UIFont.systemFontOfSize(14)
            label.center  = CGPointMake(scrollView.center.x, scrollView.center.y - CGRectGetWidth(scrollView.frame)/2 - 20)
            label.text = "向左或向右滑动Banner"
            label.textAlignment = .Center
        }
        view.addSubview(desLabel)
    }
}