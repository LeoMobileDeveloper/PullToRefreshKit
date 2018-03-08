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
        let youkuHeader = YoukuRefreshHeader()
        youkuHeader.backgroundImageView.isHidden = true
        self.refreshHeader = youkuHeader
        self.tableView.configRefreshHeader(with: youkuHeader,container:self) {
            delay(1.5, closure: {
                self.models = self.models.map({_ in random100()})
                self.tableView.reloadData()
                self.tableView.switchRefreshHeader(to: .normal(.none, 0.0));
            })
        };
        self.tableView.switchRefreshHeader(to: .refreshing)
        
        self.navigationItem.title = "Try switch"
        //Set up switch
        let sw = UISwitch()
        sw.isOn = !refreshHeader!.backgroundImageView.isHidden
        let rightItem = UIBarButtonItem(customView: sw)
        sw.addTarget(self, action: #selector(YoukuTableViewController.switchValueChanged(_:)), for: UIControlEvents.valueChanged)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    @objc func switchValueChanged(_ sender:UISwitch){
        refreshHeader?.backgroundImageView.isHidden = !sender.isOn
    }
}
