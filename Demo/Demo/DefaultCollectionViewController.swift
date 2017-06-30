//
//  DefaultCollectionViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/13.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class DefaultCollectionViewController:UIViewController,UICollectionViewDataSource{
    var collectionView:UICollectionView?
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpCollectionView()
        _ = self.collectionView?.setUpHeaderRefresh({ [weak self] in
            delay(1.0, closure: {
                self?.collectionView?.endHeaderRefreshing(.success,delay: 0.3)
            });
        })
        _ = self.collectionView?.setUpFooterRefresh({ [weak self] in
            delay(1.0, closure: {
                self?.collectionView?.endFooterRefreshing()
            });
        })
    }
    func setUpCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)
        
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    deinit{
        print("Deinit of DefaultCollectionViewController")
    }
}
