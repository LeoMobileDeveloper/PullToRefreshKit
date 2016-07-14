//
//  DefaultScrollViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class DefaultScrollViewController:UIViewController{
    var scrollView:UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        setUpScrollView()
        scrollView?.setUpHeaderRefresh({ [weak self] in
            delay(1.0, closure: { 
                self?.scrollView?.endHeaderRefreshing()
            })
        }).SetUp({ (header) in
            header.textLabel.textColor = UIColor.whiteColor()
            header.spinner.activityIndicatorViewStyle = .White
        })
    }
    func setUpScrollView(){
        self.scrollView = UIScrollView(frame: CGRectMake(0,0,300,300))
        self.scrollView?.backgroundColor = UIColor.lightGrayColor()
        self.scrollView?.center = self.view.center
        self.scrollView?.contentSize = CGSizeMake(300,600)
        self.view.addSubview(self.scrollView!)
    }
}