//
//  YoukuTableViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class YoukuTableViewController:BaseTableViewController{
    var refreshHeader:YoukuRefreshHeader?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        self.tableView.backgroundColor = UIColor(red: 232.0/255.0, green: 234.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let youkuHeader = YoukuRefreshHeader(frame: CGRectMake(0,0,CGRectGetWidth(self.view.bounds),60))
        youkuHeader.backgroundImageView.hidden = true
        self.refreshHeader = youkuHeader
        self.tableView.setUpHeaderRefresh(youkuHeader) { [weak self] in
            delay(1.5, closure: {
                self?.models = (self?.models.map({_ in random100()}))!
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            })
        }
        self.tableView.beginHeaderRefreshing()
        
        self.navigationItem.title = "Try switch"
        //Set up switch
        let sw = UISwitch()
        sw.on = !refreshHeader!.backgroundImageView.hidden
        let rightItem = UIBarButtonItem(customView: sw)
        sw.addTarget(self, action: #selector(YoukuTableViewController.switchValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func switchValueChanged(sender:UISwitch){
        refreshHeader?.backgroundImageView.hidden = !sender.on
    }
}