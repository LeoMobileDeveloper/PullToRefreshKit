//
//  DianpingRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
class DianpingRefreshHeader:UIView,RefreshableHeader{
 
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRectMake(0, 0, 60, 60)
        imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0 + 10)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - RefreshableHeader -
    func distanceToRefresh()->CGFloat{
        return 70
    }
    func percentageChangedDuringDragging(percent:CGFloat){
        imageView.hidden = false
        let adjustPercent = max(min(1.0, percent),0.0)
        let scale = 0.2 + (1.0 - 0.2) * adjustPercent;
        imageView.transform = CGAffineTransformMakeScale(scale, scale)
        let mappedIndex = Int(adjustPercent * 60)
        let imageName = "dropdown_anim__000\(mappedIndex)"
        print(imageName)
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    func willBeginRefreshing(){
        let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
            return UIImage(named:name)!
        }
        imageView.animationImages = images
        imageView.animationDuration = 0.6
        imageView.startAnimating()
    }
    func willEndRefreshing(result:RefreshResult){}
    func didEndRefreshing(result:RefreshResult){
        imageView.hidden = true
    }
    func didBeginRefreshing(){}
}