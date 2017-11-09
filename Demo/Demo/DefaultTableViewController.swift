//
//  WebviewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class DefaultTableViewController:UITableViewController{
    var models = [1,2,3,4,5,6,7,8,9,10]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.configRefreshHeader(with: DefaultRefreshHeader.header()) {
            delay(1.5, closure: {
                self.models = self.models.map({_ in random100()})
                self.tableView.reloadData()
                self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            })
        }
        self.tableView.configRefreshFooter(with: DefaultRefreshFooter.footer()) {
            delay(1.5, closure: {
                self.models.append(random100())
                self.tableView.reloadData()
                if self.models.count < 15{
                    self.tableView.switchRefreshFooter(to: .normal)
                }else{
                    self.tableView.switchRefreshFooter(to: .noMoreData)
                }
            })
        };
        self.tableView.switchRefreshHeader(to: .refreshing)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
        return cell!
    }
    deinit{
        print("Deinit of DefaultTableViewController")
    }
}
