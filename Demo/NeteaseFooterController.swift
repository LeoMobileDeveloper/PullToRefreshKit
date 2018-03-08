//
//  NeteaseFooterController.swift
//  Demo
//
//  Created by Leo on 2017/11/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit

class NeteaseFooterController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.configRefreshFooter(with: NeteaseNewsFooter()) { [unowned self] in
            delay(2.0, closure: {
                self.models.append(random100())
                self.tableView.reloadData()
                if self.models.count == 12{
                    self.tableView.switchRefreshFooter(to: .noMoreData)
                }else{
                    self.tableView.switchRefreshFooter(to: .normal)
                }
            });
        };
    }
}
