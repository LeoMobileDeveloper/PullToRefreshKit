//
//  CurveRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/3.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class CurveRefreshHeader: UIView,RefreshableHeader{
    let imageView = UIImageView()
    let bgColor = UIColor(red: 77.0/255.0, green: 184.0/255.0, blue: 255.0/255.0, alpha: 0.65)
    let totalHeight = UIScreen.mainScreen().bounds.size.height
    let maskLayer = CAShapeLayer()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let backgroundLayer = CALayer()
    override init(frame: CGRect) {
        let adjustFrame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, totalHeight)
        super.init(frame: adjustFrame)
        imageView.frame = CGRectMake(0, 0, 25, 25)
        imageView.image = UIImage(named: "arrow_downWhite")
        self.layer.addSublayer(backgroundLayer)
        backgroundLayer.backgroundColor = bgColor.CGColor
        backgroundLayer.mask = maskLayer
        addSubview(imageView)
        addSubview(spinner)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds) - 30)
        imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds) - 30)
        backgroundLayer.bounds = self.layer.bounds
        backgroundLayer.position = CGPointMake(CGRectGetWidth(self.layer.bounds)/2,CGRectGetHeight(self.layer.bounds)/2)
        maskLayer.bounds = self.layer.bounds
        maskLayer.anchorPoint = CGPointMake(0.0, 0.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //监听状态变化
    func stateDidChanged(oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .Pulling && oldState == .Idle{
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001))
            })
        }
        if newState == .Idle{
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
    }
    func createLayerWithY(y:CGFloat,controlPoint:CGPoint)->UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 0));
        bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(self.bounds), 0))
        bezierPath.addLineToPoint(CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - y))
        bezierPath.addQuadCurveToPoint(CGPointMake(0, CGRectGetHeight(self.bounds) - y), controlPoint: controlPoint)
        bezierPath.addLineToPoint(CGPointMake(0, 0))
        return bezierPath
    }
    
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 60
    }
    //监听百分比变化
    func percentUpdateDuringScrolling(percent:CGFloat){
        let heightScrolled = 60 * percent;
        let adjustHeight = heightScrolled < 60 ? heightScrolled : 60;
        print(adjustHeight)
        let controlPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) + adjustHeight)
        let bezierPath = createLayerWithY(adjustHeight,controlPoint: controlPoint)
        self.maskLayer.path = bezierPath.CGPath
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        spinner.startAnimating()
        let controPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) - 60.0)
        self.maskLayer.path = createLayerWithY(60, controlPoint: controPoint).CGPath
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(result:RefreshResult){
        spinner.stopAnimating()
        imageView.transform = CGAffineTransformIdentity
        imageView.image = UIImage(named: "success")
    }
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(result:RefreshResult){
        imageView.image = UIImage(named: "arrow_downWhite")
    }
}