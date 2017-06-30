//
//  DianpingTableviewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class DianpingTableviewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        self.tableView.backgroundColor = UIColor(red: 232.0/255.0, green: 234.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let taobaoHeader = DianpingRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 60))
        _ = self.tableView.setUpHeaderRefresh(taobaoHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            })
        }
        self.tableView.beginHeaderRefreshing()
    }
}
