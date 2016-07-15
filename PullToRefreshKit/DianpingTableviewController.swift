//
//  DianpingTableviewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class DianpingTableviewController:CustomBaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        self.tableView.backgroundColor = UIColor(red: 232.0/255.0, green: 234.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let taobaoHeader = DianpingRefreshHeader(frame: CGRectMake(0,0,CGRectGetWidth(self.view.bounds),60))
        self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(.Success)
            })
        }
    }
}