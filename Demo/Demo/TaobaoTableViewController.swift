//
//  TaobaoTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
class TaobaoTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        let taobaoHeader = TaoBaoRefreshHeader()
        self.tableView.configRefreshHeader(with: taobaoHeader) {
            self.models = self.models.map({_ in random100()})
            self.tableView.reloadData()
            self.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
        };
    }
}
