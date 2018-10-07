//
//  TaoBaoRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class TaoBaoRefreshHeader:UIView,RefreshableHeader{
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let arrowLayer = CAShapeLayer()
    fileprivate let textLabel = UILabel()
    fileprivate let strokeColor = UIColor(red: 135.0/255.0, green: 136.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    fileprivate let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 230, height: 35))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCircleLayer()
        setUpArrowLayer()
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.text = "下拉即可刷新..."
        imageView.image = UIImage(named: "taobaoLogo")
        self.addSubview(imageView)
        self.addSubview(textLabel)
 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //放置Views和Layer
        textLabel.frame = CGRect(x: 0,y: 0,width: 120, height: 40)
        imageView.center = CGPoint(x: self.frame.width/2, y: self.frame.height - 60 - 18)
        textLabel.center = CGPoint(x: self.frame.width/2 + 20, y: self.frame.height - 30)
        self.arrowLayer.position = CGPoint(x: self.frame.width/2 - 60, y: self.frame.height - 30)
        self.circleLayer.position = CGPoint(x: self.frame.width/2 - 60, y: self.frame.height - 30)
    }
    func setUpArrowLayer(){
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 15))
        bezierPath.addLine(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 25,y: 20))
        bezierPath.move(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 15, y: 20))
        self.arrowLayer.path = bezierPath.cgPath
        self.arrowLayer.strokeColor = UIColor.lightGray.cgColor
        self.arrowLayer.fillColor = UIColor.clear.cgColor
        self.arrowLayer.lineWidth = 1.0
        #if swift(>=4.2)
        self.circleLayer.lineCap = CAShapeLayerLineCap.round
        #else
        self.circleLayer.lineCap = kCALineCapRound
        #endif
        self.arrowLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        self.arrowLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.arrowLayer)
    }
    func setUpCircleLayer(){
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20),
                                      radius: 12.0,
                                      startAngle:-CGFloat.pi/2,
                                      endAngle: CGFloat.pi/2.0 * 3.0,
                                      clockwise: true)
        self.circleLayer.path = bezierPath.cgPath
        self.circleLayer.strokeColor = UIColor.lightGray.cgColor
        self.circleLayer.fillColor = UIColor.clear.cgColor
        self.circleLayer.strokeStart = 0.05
        self.circleLayer.strokeEnd = 0.05
        self.circleLayer.lineWidth = 1.0
        #if swift(>=4.2)
        self.circleLayer.lineCap = CAShapeLayerLineCap.round
        #else
        self.circleLayer.lineCap = kCALineCapRound
        #endif
        self.circleLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        self.circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.circleLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - RefreshableHeader -
    func heightForHeader() -> CGFloat {
        return 100
    }
    
    func heightForFireRefreshing() -> CGFloat {
        return 60.0
    }
    
    func heightForRefreshingState() -> CGFloat {
        return 60.0
    }
    
    func percentUpdateDuringScrolling(_ percent:CGFloat){
        let adjustPercent = max(min(1.0, percent),0.0)
        if adjustPercent  == 1.0{
            textLabel.text = "释放即可刷新..."
        }else{
            textLabel.text = "下拉即可刷新..."
        }
        self.circleLayer.strokeEnd = 0.05 + 0.9 * adjustPercent
    }
    
    func didBeginRefreshingState(){
        self.circleLayer.strokeEnd = 0.95
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.circleLayer.add(rotateAnimation, forKey: "rotate")
        self.arrowLayer.isHidden = true
        textLabel.text = "刷新中..."
    }
    
    func didBeginHideAnimation(_ result:RefreshResult){
        transitionWithOutAnimation {
            self.circleLayer.strokeEnd = 0.05
        };
        self.circleLayer.removeAllAnimations()
    }
    
    func didCompleteHideAnimation(_ result:RefreshResult){
        transitionWithOutAnimation { 
            self.circleLayer.strokeEnd = 0.05
        };
        self.arrowLayer.isHidden = false
        textLabel.text = "下拉即可刷新"
    }
    
    func transitionWithOutAnimation(_ clousre:()->()){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        clousre()
        CATransaction.commit()
    }
}
