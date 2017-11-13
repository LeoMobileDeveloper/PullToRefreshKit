//
//  YahooWeatherTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class YahooWeatherTableViewController:BaseTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        let yahooHeader = YahooWeatherRefreshHeader()
        tableView.configRefreshHeader(with: yahooHeader) { [weak self] in
            delay(2.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
            })
            
        };
    }
}
