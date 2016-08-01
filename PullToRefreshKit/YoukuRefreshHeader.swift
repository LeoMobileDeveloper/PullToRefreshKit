//
//  YoukuRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

//一共高度是两百
private var frameHeight:CGFloat{
    get{
        return UIScreen.mainScreen().bounds.size.width * 328.0/571.0
    }
}
class YoukuRefreshHeader:UIView,RefreshableHeader{
    let iconImageView = UIImageView()// 这个ImageView用来显示下拉箭头
    let rotatingImageView = UIImageView()
    let backgroundImageView = UIImageView() //这个ImageView用来显示广告的

    override init(frame: CGRect) {
        let adjustFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight)
        super.init(frame: adjustFrame)
        iconImageView.frame = CGRectMake(0, 0, 25, 25)
        iconImageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0)
        iconImageView.image = UIImage(named: "youku_down")
        rotatingImageView.image = UIImage(named: "youku_refreshing")
        rotatingImageView.frame = CGRectMake(0, 0, 25, 25)
        backgroundImageView.image = UIImage(named: "youku_ad.jpeg")
        addSubview(backgroundImageView)
        addSubview(iconImageView)
        addSubview(rotatingImageView)
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let superView = newSuperview{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, superView.frame.size.width, frameHeight)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = self.bounds
        iconImageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, frameHeight - 30.0)
        rotatingImageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, frameHeight - 30.0)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 60
    }
    //监听状态变化
    func stateDidChanged(oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .Pulling && oldState == .Idle{
            UIView.animateWithDuration(0.4, animations: {
                self.iconImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001))
            })
        }
        if newState == .Idle{
            UIView.animateWithDuration(0.4, animations: {
                self.iconImageView.transform = CGAffineTransformIdentity
            })
        }
    }
    //松手即将刷新的状态
    func didBeginrefreshingState(){
        self.iconImageView.hidden = true
        self.rotatingImageView.hidden = false
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(double: M_PI * 2.0)
        rotateAnimation.duration = 0.8
        rotateAnimation.cumulative = true
        rotateAnimation.repeatCount = 10000000
        self.rotatingImageView.layer.addAnimation(rotateAnimation, forKey: "rotate")
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(result:RefreshResult){
        self.rotatingImageView.hidden = true
        self.iconImageView.hidden = false
        self.iconImageView.layer.removeAllAnimations()
        self.iconImageView.layer.transform = CATransform3DIdentity
        self.iconImageView.image = UIImage(named: "youku_down")
    }
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(result:RefreshResult){
    }
}