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
    //监听百分比变化
    func percentUpdateWhenNotRefreshing(percent:CGFloat){
        imageView.hidden = (percent == 0)
        let adjustPercent = max(min(1.0, percent),0.0)
        let scale = 0.2 + (1.0 - 0.2) * adjustPercent;
        imageView.transform = CGAffineTransformMakeScale(scale, scale)
        let mappedIndex = Int(adjustPercent * 60)
        let imageName = "dropdown_anim__000\(mappedIndex)"
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    //松手即将刷新的状态
    func releaseWithRefreshingState(){
        let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
            return UIImage(named:name)!
        }
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.15
        imageView.startAnimating()
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(result:RefreshResult){
        
    }
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(result:RefreshResult){
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.hidden = true
    }
}