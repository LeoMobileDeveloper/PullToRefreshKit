//
//  NeteaseNewsFooter.swift
//  Demo
//
//  Created by Leo on 2017/11/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

import UIKit
import PullToRefreshKit

class NeteaseNewsFooter: UIView, RefreshableFooter {
    var containerView = UIView()
    var textlabel = UILabel()
    var shapeLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        textlabel.font = UIFont.systemFont(ofSize: 15)
        textlabel.textColor = UIColor.darkGray
        containerView.layer.cornerRadius = 4.0;
        containerView.layer.masksToBounds = true
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.layer.shadowRadius = 10.0;
        containerView.layer.shadowColor = UIColor.black.cgColor;
        containerView.layer.shadowOpacity = 0.20;
        containerView.layer.addSublayer(shapeLayer)
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.borderWidth = 0.5
        containerView.addSubview(textlabel)
        setUpCircleLayer()
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRect(x: 8.0, y: 10.0, width: self.frame.width - 16.0, height: self.frame.size.height - 20.0)
        textlabel.sizeToFit()
        textlabel.center = CGPoint(x: containerView.frame.size.width / 2.0, y: containerView.frame.size.height/2.0)
        shapeLayer.position = CGPoint(x: textlabel.frame.origin.x - 30.0, y: containerView.frame.size.height/2.0 + 10.0)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpCircleLayer(){
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20),
                                      radius: 12.0,
                                      startAngle:-CGFloat.pi/2,
                                      endAngle: CGFloat.pi/2.0 * 3.0,
                                      clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeStart = 0.3
        shapeLayer.strokeEnd = 0.8
        shapeLayer.lineWidth = 1.0
        #if swift(>=4.2)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        #else
        shapeLayer.lineCap = kCALineCapRound
        #endif
        shapeLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - RefreshableHeader -

    func heightForFooter() -> CGFloat {
        return 65
    }
    
    func didUpdateToNoMoreData() {
        textlabel.text = "到底了..."
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didResetToDefault() {
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didEndRefreshing() {
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didBeginRefreshing() {
        textlabel.text = "正在加载中..."
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        shapeLayer.add(rotateAnimation, forKey: "rotate")
        setNeedsLayout()
        shapeLayer.isHidden = false
    }
    
    func shouldBeginRefreshingWhenScroll() -> Bool {
        return true
    }
    
}
