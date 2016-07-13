//
//  ViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UITableViewController {
    var models = [SectionModel]()
    override func viewDidLoad() {
        let section0 = SectionModel(rowsCount: 4,
                                    sectionTitle:"默认",
                                    rowsTitles: ["默认header","默认Footer","默认left","默认Right"],
                                    rowsTargetControlerNames:["DefaultHeaderController","DefaultFooterController","DefaultLeftController","DefaultRightController"])
        let section1 = SectionModel(rowsCount: 4,
                                    sectionTitle:"属性配置",
                                    rowsTitles: ["设置默认header","设置默认Footer","设置默认left","设置默认Right"],
                                    rowsTargetControlerNames:["DefaultHeaderController","DefaultFooterController","DefaultLeftController","DefaultRightController"])
        let section2 = SectionModel(rowsCount: 4,
                                    sectionTitle:"自定义",
                                    rowsTitles: ["自定义header","自定义Footer","自定义left","自定义Right"],
                                    rowsTargetControlerNames:["DefaultHeaderController","DefaultFooterController","DefaultLeftController","DefaultRightController"])
        models.append(section0)
        models.append(section1)
        models.append(section2)
        self.tableView.setUpHeaderRefresh { [weak self] in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self?.tableView.endHeaderRefreshing(.Success)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return models.count
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionModel = models[section]
        return sectionModel.sectionTitle
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = models[section]
        return sectionModel.rowsCount
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        let sectionModel = models[indexPath.section]
        cell?.textLabel?.text = sectionModel.rowsTitles[indexPath.row]
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

