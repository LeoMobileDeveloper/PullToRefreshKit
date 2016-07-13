//
//  SecondViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController:UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(600, CGRectGetHeight(scrollView.frame))
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.pagingEnabled = true
        scrollView.setUpRightRefresh { [weak self] in

        }
        scrollView.setUpLeftRefresh { [weak self] in
            
        }
        let subview1 = UIView(frame: CGRectMake(0,0,300,200))
        subview1.backgroundColor = UIColor.redColor()
        scrollView.addSubview(subview1)
        
        let subview2 = UIView(frame: CGRectMake(300,0,300,200))
        subview2.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(subview2)
    }
    deinit{
        print("Deinit of SecondViewController")
    }
}