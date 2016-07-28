//
//  TaoBaoRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit


class TaoBaoRefreshHeader:UIView,RefreshableHeader{
    private let circleLayer = CAShapeLayer()
    private let arrowLayer = CAShapeLayer()
    private let textLabel = UILabel()
    private let strokeColor = UIColor(red: 135.0/255.0, green: 136.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCircleLayer()
        setUpArrowLayer()
        textLabel.frame = CGRectMake(0,0,120, 40)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.lightGrayColor()
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.text = "下拉即可刷新..."
        let imageView = UIImageView(frame: CGRectMake(0, 0, 230, 35))
        imageView.image = UIImage(named: "taobaoLogo")
        self.addSubview(imageView)
        self.addSubview(textLabel)
        //放置Views和Layer
        imageView.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame) - 60 - 18)
        textLabel.center = CGPointMake(CGRectGetWidth(frame)/2 + 20, CGRectGetHeight(frame) - 30)
        self.arrowLayer.position = CGPointMake(CGRectGetWidth(frame)/2 - 60, CGRectGetHeight(frame) - 30)
        self.circleLayer.position = CGPointMake(CGRectGetWidth(frame)/2 - 60, CGRectGetHeight(frame) - 30)
    }
    func setUpArrowLayer(){
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(20, 15))
        bezierPath.addLineToPoint(CGPointMake(20, 25))
        bezierPath.addLineToPoint(CGPointMake(25,20))
        bezierPath.moveToPoint(CGPointMake(20, 25))
        bezierPath.addLineToPoint(CGPointMake(15, 20))
        self.arrowLayer.path = bezierPath.CGPath
        self.arrowLayer.strokeColor = UIColor.lightGrayColor().CGColor
        self.arrowLayer.fillColor = UIColor.clearColor().CGColor
        self.arrowLayer.lineWidth = 1.0
        self.arrowLayer.lineCap = kCALineCapRound
        self.arrowLayer.bounds = CGRectMake(0, 0,40, 40)
        self.arrowLayer.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer.addSublayer(self.arrowLayer)
    }
    func setUpCircleLayer(){
        let bezierPath = UIBezierPath(arcCenter: CGPointMake(20, 20),
                                      radius: 12.0,
                                      startAngle:CGFloat(-M_PI/2),
                                      endAngle: CGFloat(M_PI_2 * 3),
                                      clockwise: true)
        self.circleLayer.path = bezierPath.CGPath
        self.circleLayer.strokeColor = UIColor.lightGrayColor().CGColor
        self.circleLayer.fillColor = UIColor.clearColor().CGColor
        self.circleLayer.strokeStart = 0.05
        self.circleLayer.strokeEnd = 0.05
        self.circleLayer.lineWidth = 1.0
        self.circleLayer.lineCap = kCALineCapRound
        self.circleLayer.bounds = CGRectMake(0, 0,40, 40)
        self.circleLayer.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer.addSublayer(self.circleLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - RefreshableHeader -
    func distanceToRefresh()->CGFloat{
        return 60
    }
    func percentUpdateWhenNotRefreshing(percent:CGFloat){
        let adjustPercent = max(min(1.0, percent),0.0)
        if adjustPercent  == 1.0{
            textLabel.text = "释放即可刷新..."
        }else{
            textLabel.text = "下拉即可刷新..."
        }
        self.circleLayer.strokeEnd = 0.05 + 0.9 * adjustPercent
    }
    func releaseWithRefreshingState(){
        self.circleLayer.strokeEnd = 0.95
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(double: M_PI * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.cumulative = true
        rotateAnimation.repeatCount = 10000000
        self.circleLayer.addAnimation(rotateAnimation, forKey: "rotate")
        self.arrowLayer.hidden = true
        textLabel.text = "刷新中..."
    }
    func didBeginEndRefershingAnimation(result:RefreshResult){
        transitionWithOutAnimation {
            self.circleLayer.strokeEnd = 0.05
        };
        self.circleLayer.removeAllAnimations()
    }
    func didCompleteEndRefershingAnimation(result:RefreshResult){
        transitionWithOutAnimation { 
            self.circleLayer.strokeEnd = 0.05
        };
        self.arrowLayer.hidden = false
        textLabel.text = "下拉即可刷新"
    }
    func transitionWithOutAnimation(clousre:()->()){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        clousre()
        CATransaction.commit()
    }
}