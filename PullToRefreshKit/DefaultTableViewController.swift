//
//  WebviewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
class DefaultTableViewController:UITableViewController{
    var models = [1,2,3,4,5,6,7,8,9,10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.setUpHeaderRefresh { [weak self] in
           delay(1.5, closure: { 
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(.Success)
           })
        }
        self.tableView.setUpFooterRefresh {  [weak self] in
            delay(1.5, closure: {
                self?.models.append(random100())
                self?.tableView.reloadData()
                self?.tableView.endFooterRefreshing()
            })
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(models[indexPath.row])"
        return cell!
    }
    deinit{
        print("Deinit of DefaultTableViewController")
    }
}