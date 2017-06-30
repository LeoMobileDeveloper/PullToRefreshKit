//
//  CurveRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/3.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class CurveRefreshHeader: UIView,RefreshableHeader{
    let imageView = UIImageView()
    let bgColor = UIColor(red: 77.0/255.0, green: 184.0/255.0, blue: 255.0/255.0, alpha: 0.65)
    let totalHeight = UIScreen.main.bounds.size.height
    let maskLayer = CAShapeLayer()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let backgroundLayer = CALayer()
    override init(frame: CGRect) {
        let adjustFrame = CGRect(x: frame.origin.x, y: frame.origin.y , width: frame.size.width, height: totalHeight)
        super.init(frame: adjustFrame)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.image = UIImage(named: "arrow_downWhite")
        self.layer.addSublayer(backgroundLayer)
        backgroundLayer.backgroundColor = bgColor.cgColor
        backgroundLayer.mask = maskLayer
        addSubview(imageView)
        addSubview(spinner)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height - 30)
        imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height - 30)
        backgroundLayer.bounds = self.layer.bounds
        backgroundLayer.position = CGPoint(x: self.layer.bounds.width/2,y: self.layer.bounds.height/2)
        maskLayer.bounds = self.layer.bounds
        maskLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //监听状态变化
    func stateDidChanged(_ oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .pulling && oldState == .idle{
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi+0.000001)
            })
        }
        if newState == .idle{
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        }
    }
    func createLayerWithY(_ y:CGFloat,controlPoint:CGPoint)->UIBezierPath{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0));
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - y))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height - y), controlPoint: controlPoint)
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        return bezierPath
    }
    
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 60
    }
    //监听百分比变化
    func percentUpdateDuringScrolling(_ percent:CGFloat){
        let heightScrolled = 60 * percent;
        let adjustHeight = heightScrolled < 60 ? heightScrolled : 60;
        print(adjustHeight)
        let controlPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height + adjustHeight)
        let bezierPath = createLayerWithY(adjustHeight,controlPoint: controlPoint)
        self.maskLayer.path = bezierPath.cgPath
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        spinner.startAnimating()
        let controPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height - 60.0)
        self.maskLayer.path = createLayerWithY(60, controlPoint: controPoint).cgPath
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(_ result:RefreshResult){
        spinner.stopAnimating()
        imageView.transform = CGAffineTransform.identity
        imageView.image = UIImage(named: "success")
    }
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(_ result:RefreshResult){
        imageView.image = UIImage(named: "arrow_downWhite")
    }
}
