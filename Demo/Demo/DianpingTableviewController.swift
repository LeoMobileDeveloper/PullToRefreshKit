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
        self.tableView.configRefreshHeader(with: DianpingRefreshHeader(),container:self) { [weak self] in
            delay(1.5, closure: {
                guard let vc = self else{
                    return;
                }
                vc.models = vc.models.map{_ in random100()}
                vc.tableView.reloadData()
                vc.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
            })
        };
        self.tableView.switchRefreshHeader(to: .refreshing)
    }
}
