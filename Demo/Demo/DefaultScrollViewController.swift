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
    var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        setUpScrollView()
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = UIColor.white;
        #if swift(>=4.2)
        header.spinner.style = .white
        #else
        header.spinner.activityIndicatorViewStyle = .white
        #endif
        scrollView.configRefreshHeader(with: header,container:self) {
            delay(1.0, closure: {
                self.scrollView.switchRefreshHeader(to: .normal(.success, 0.5));
            })
        };
    }
    
    func setUpScrollView(){
        self.scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: 300,height: 300))
        self.scrollView?.backgroundColor = UIColor.lightGray
        self.scrollView?.center = self.view.center
        self.scrollView?.contentSize = CGSize(width: 300,height: 600)
        self.view.addSubview(self.scrollView!)
    }
}
