//
//  DefaultCollectionViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class DefaultCollectionViewController:UIViewController,UICollectionViewDataSource{
    var collectionView:UICollectionView?
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpCollectionView()
        self.collectionView?.setUpHeaderRefresh({ [weak self] in
            delay(1.0, closure: {
                self?.collectionView?.endHeaderRefreshing(.Success,delay: 0.3)
            });
        })
        self.collectionView?.setUpFooterRefresh({ [weak self] in
            delay(1.0, closure: {
                self?.collectionView?.endFooterRefreshing()
            });
        })
    }
    func setUpCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.itemSize = CGSizeMake(100, 100)
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
    deinit{
        print("Deinit of DefaultCollectionViewController")
    }
}