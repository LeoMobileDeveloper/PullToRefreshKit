//
//  ViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import AudioToolbox
import PullToRefreshKit
/* 
    如果你喜欢这个库，一个★就是对我最好的支持，项目地址 https://github.com/LeoMobileDeveloper/PullToRefreshKit
 */
class MainViewController: UITableViewController {
    var models = [SectionModel]()
    override func viewDidLoad() {
        let section0 = SectionModel(rowsCount: 5,
                                    sectionTitle:"Default",
                                    rowsTitles: ["Tableview","CollectionView","ScrollView","Banners","WebView"],
                                    rowsTargetControlerNames:["DefaultTableViewController","DefaultCollectionViewController","DefaultScrollViewController","DefaultBannerController","DefaultWebViewController"])
        let section1 = SectionModel(rowsCount: 1,
                                    sectionTitle:"Build In",
                                    rowsTitles: ["Elastic",],
                                    rowsTargetControlerNames:["ElasticHeaderTableViewController"])
        
        let section2 = SectionModel(rowsCount: 2,
                                    sectionTitle:"Config Default",
                                    rowsTitles: ["Header/Footer","Left/Right"],
                                    rowsTargetControlerNames:["ConfigDefaultHeaderFooterController","ConfigBannerController"])
        let section3 = SectionModel(rowsCount: 6,
                                    sectionTitle:"Customize",
                                    rowsTitles: ["YahooWeather","Curve Mask","Youku","TaoBao","QQ Video","DianPing"],
                                    rowsTargetControlerNames:["YahooWeatherTableViewController","CurveMaskTableViewController","YoukuTableViewController","TaobaoTableViewController","QQVideoTableviewController","DianpingTableviewController"])
        models.append(section0)
        models.append(section1)
        models.append(section2)
        models.append(section3)
        self.tableView.setUpHeaderRefresh { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.tableView.endHeaderRefreshing(.success,delay:0.3)
            }
        }.SetUp { (header) in
            header.setThemeColor(themeColor: UIColor.blue)
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionModel = models[section]
        return sectionModel.sectionTitle
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = models[section]
        return sectionModel.rowsCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let sectionModel = models[(indexPath as NSIndexPath).section]
        cell?.textLabel?.text = sectionModel.rowsTitles[(indexPath as NSIndexPath).row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionModel = models[(indexPath as NSIndexPath).section]
        var className = sectionModel.rowsTargetControlerNames[(indexPath as NSIndexPath).row]
        className = "Demo.\(className)"
        if let cls = NSClassFromString(className) as? UIViewController.Type{
            let dvc = cls.init()
            self.navigationController?.pushViewController(dvc, animated: true)
        }

    }
}

