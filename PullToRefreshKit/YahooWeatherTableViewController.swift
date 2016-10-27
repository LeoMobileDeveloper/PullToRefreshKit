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
        let yahooHeader = YahooWeatherRefreshHeader(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width,height: UIScreen.main.bounds.height))
        _ = self.tableView.setUpHeaderRefresh(yahooHeader) { [weak self] in
            delay(2.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            })
        }
        //        self.tableView.beginHeaderRefreshing()
    }
}
