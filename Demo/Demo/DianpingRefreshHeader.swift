//
//  DianpingRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class DianpingRefreshHeader:UIView,RefreshableHeader{
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 70
    }
    //监听百分比变化
    func percentUpdateDuringScrolling(_ percent:CGFloat){
        imageView.isHidden = (percent == 0)
        let adjustPercent = max(min(1.0, percent),0.0)
        let scale = 0.2 + (1.0 - 0.2) * adjustPercent;
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        let mappedIndex = Int(adjustPercent * 60)
        let imageName = "dropdown_anim__000\(mappedIndex)"
        let image = UIImage(named: imageName)
        imageView.image = image
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
            return UIImage(named:name)!
        }
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.15
        imageView.startAnimating()
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(_ result:RefreshResult){}
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(_ result:RefreshResult){
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.isHidden = true
    }
}
