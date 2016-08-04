//
//  YahooWeatherRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/2.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class YahooWeatherRefreshHeader: UIView,RefreshableHeader{
    
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRectMake(0, 0, 27, 10)
        imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0)
        imageView.image = UIImage(named: "loading15")
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 50
    }
    func stateDidChanged(oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .Pulling{
            UIView.animateWithDuration(0.3, animations: {
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
        if newState == .Idle{
            UIView.animateWithDuration(0.3, animations: {
                self.imageView.transform = CGAffineTransformMakeTranslation(0, -50)
            })
        }
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        imageView.image = nil
        let images = (0...29).map{return $0 < 10 ? "loading0\($0)" : "loading\($0)"}
        imageView.animationImages = images.map{return UIImage(named:$0)!}
        imageView.animationDuration = Double(images.count) * 0.04
        imageView.startAnimating()
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(result:RefreshResult){}
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(result:RefreshResult){
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.image = UIImage(named: "loading15")
    }
}