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
        self.tableView.configRefreshHeader(with: DianpingRefreshHeader()) { [unowned self] in
            delay(1.5, closure: {
                self.models = self.models.map{_ in random100()}
                self.tableView.reloadData()
                self.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
            })
        };
        self.tableView.switchRefreshHeader(to: .refreshing)
    }
}
