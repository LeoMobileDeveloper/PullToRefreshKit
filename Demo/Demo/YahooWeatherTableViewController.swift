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
        tableView.configRefreshHeader(with: yahooHeader,container:self) { [weak self] in
            delay(2.5, closure: {
                guard let vc = self else{
                    return;
                }
                vc.models = vc.models.map{_ in random100()}
                vc.tableView.reloadData()
                vc.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
            })
            
        };
    }
}
