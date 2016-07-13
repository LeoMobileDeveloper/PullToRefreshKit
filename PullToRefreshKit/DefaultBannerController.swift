//
//  DefaultBannerController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
class DefaultBannerController: UIViewController {
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Banners"
        self.automaticallyAdjustsScrollViewInsets = false
        setUpViews()
        scrollView.setUpLeftRefresh { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        }
        scrollView.setUpRightRefresh { [weak self] in
            let nvc = DefaultBannerController()
            self?.navigationController?.pushViewController(nvc, animated: true)
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
    }
}