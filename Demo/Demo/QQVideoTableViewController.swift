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
        let qqHeader = QQVideoRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        self.tableView.configRefreshHeader(with: qqHeader,container:self) { [weak self] in
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
