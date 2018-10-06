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
        self.tableView.configRefreshFooter(with: NeteaseNewsFooter(),container:self) { [weak self] in
            delay(2.0, closure: {
                guard let vc = self else{
                    return;
                }
                vc.models.append(random100())
                vc.tableView.reloadData()
                if vc.models.count == 12{
                    vc.tableView.switchRefreshFooter(to: .noMoreData)
                }else{
                    vc.tableView.switchRefreshFooter(to: .normal)
                }
            });
        };
    }
}
