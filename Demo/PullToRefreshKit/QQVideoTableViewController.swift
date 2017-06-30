//
//  QQVideoTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class QQVideoTableviewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let taobaoHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
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
