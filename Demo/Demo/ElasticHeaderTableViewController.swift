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
        //Setup
        //        self.tableView.backgroundColor = UIColor(red: 232.0/255.0, green: 234.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let elasticHeader = ElasticRefreshHeader()
        self.tableView.configRefreshHeader(with: elasticHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5));
            })
        };
    }
}
