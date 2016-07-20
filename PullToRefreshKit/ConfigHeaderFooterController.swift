//
//  ConfigDefaultHeaderFooterController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class ConfigDefaultHeaderFooterController: UITableViewController {
    var models = [1,2,3,4,5,6,7,8,9,10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Header
        self.tableView.setUpHeaderRefresh { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(.Success)
            })
        }.SetUp { (header) in
            header.setText("Pull to refresh", mode: .pullToRefresh)
            header.setText("Release to refresh", mode: .releaseToRefresh)
            header.setText("Success", mode: .refreshSuccess)
            header.setText("Refreshing...", mode: .refreshing)
            header.setText("Failed", mode: .refreshFailure)
            header.setText("Error", mode: .refreshError)
            header.textLabel.textColor = UIColor.orangeColor()
            header.imageView.image = nil
        }
        //Footer
        
        self.tableView.setUpFooterRefresh {  [weak self] in
            delay(1.5, closure: {
                self?.models.append(random100())
                self?.tableView.reloadData()
                self?.tableView.endFooterRefreshing()
            })
        }.SetUp { (footer) in
            footer.setText("Pull up to refresh", mode: RefreshKitFooterText.PullToRefresh)
            footer.setText("No data any more", mode: RefreshKitFooterText.NoMoreData)
            footer.setText("Refreshing...", mode: RefreshKitFooterText.Refreshing)
            footer.setText("Tap to load more", mode: RefreshKitFooterText.TapToRefresh)
            footer.textLabel.textColor  = UIColor.orangeColor()
            footer.refreshMode = .Tap
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
