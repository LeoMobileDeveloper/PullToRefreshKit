//
//  ViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import AudioToolbox

/* 
    如果你喜欢这个库，一个★就是对我最好的支持，项目地址 https://github.com/LeoMobileDeveloper/PullToRefreshKit
 */
class MainViewController: UITableViewController {
    var models = [SectionModel]()
    override func viewDidLoad() {
        let section0 = SectionModel(rowsCount: 4,
                                    sectionTitle:"默认",
                                    rowsTitles: ["Tableview","CollectionView","ScrollView","Banners"],
                                    rowsTargetControlerNames:["DefaultTableViewController","DefaultCollectionViewController","DefaultScrollViewController","DefaultBannerController",])
        let section1 = SectionModel(rowsCount: 2,
                                    sectionTitle:"属性配置",
                                    rowsTitles: ["配置Header/Footer属性","配置Left/Right属性"],
                                    rowsTargetControlerNames:["ConfigDefaultHeaderFooterController","ConfigBannerController"])
        let section2 = SectionModel(rowsCount: 1,
                                    sectionTitle:"自定义",
                                    rowsTitles: ["淘宝下拉刷新",],
                                    rowsTargetControlerNames:["TaobaoTableViewController"])
        models.append(section0)
        models.append(section1)
        models.append(section2)
        self.tableView.setUpHeaderRefresh { [weak self] in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self?.tableView.endHeaderRefreshing(.Success)
            }
        }
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
        let sectionModel = models[indexPath.section]
        var className = sectionModel.rowsTargetControlerNames[indexPath.row]
        className = "PullToRefreshKit.\(className)"
        if let cls = NSClassFromString(className) as? UIViewController.Type{
            let dvc = cls.init()
            self.navigationController?.pushViewController(dvc, animated: true)
        }

    }
}

