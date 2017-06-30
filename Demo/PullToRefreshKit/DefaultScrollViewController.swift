//
//  DefaultScrollViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class DefaultScrollViewController:UIViewController{
    var scrollView:UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        setUpScrollView()
        _ = scrollView?.setUpHeaderRefresh({ [weak self] in
            delay(1.0, closure: { 
                self?.scrollView?.endHeaderRefreshing(.success,delay: 0.3)
            })
        }).SetUp({ (header) in
            header.textLabel.textColor = UIColor.white
            header.spinner.activityIndicatorViewStyle = .white
        })
    }
    func setUpScrollView(){
        self.scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: 300,height: 300))
        self.scrollView?.backgroundColor = UIColor.lightGray
        self.scrollView?.center = self.view.center
        self.scrollView?.contentSize = CGSize(width: 300,height: 600)
        self.view.addSubview(self.scrollView!)
    }
}
