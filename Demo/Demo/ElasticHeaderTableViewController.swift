//
//  ElasticHeaderTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/30.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import PullToRefreshKit
import UIKit

class ElasticHeaderTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let elasticHeader = ElasticRefreshHeader()
        self.tableView.configRefreshHeader(with: elasticHeader) { [unowned self] in
            delay(1.5, closure: {
                self.models = self.models.map{_ in random100()}
                self.tableView.reloadData()
                self.tableView.switchRefreshHeader(to: .normal(.success, 0.5));
            })
        };
    }
}
