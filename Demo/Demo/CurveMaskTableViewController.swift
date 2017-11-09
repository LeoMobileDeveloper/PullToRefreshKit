//
//  CurveMaskTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/4.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class CurveMaskTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        let curveHeader = CurveRefreshHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        self.tableView.configRefreshHeader(with: curveHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.switchRefreshHeader(to: .normal(.none, 0.5))
            })
        };
    }
}
