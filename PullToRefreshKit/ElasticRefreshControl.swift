//
//  ElasticRefreshControl.swift
//  SWTest
//
//  Created by huangwenchen on 16/7/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class ElasticRefreshControl: UIView {
    public let spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    var radius:CGFloat{
        get{
            return totalHeight / 4
        }
    }
    public var progress:CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    public var margin:CGFloat = 4.0{
        didSet{
            setNeedsDisplay()
        }
    }
    var arrowRadius:CGFloat{
        get{
            return radius * 0.5 - 0.3 * radius * progress
        }
    }
    var adjustedProgress:CGFloat{
        get{
            return min(max(progress,0.0),1.0)
        }
    }
    let totalHeight:CGFloat = 60
    public var arrowColor = UIColor.whiteColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    public var elasticTintColor = UIColor.init(white: 0.5, alpha: 0.6){
        didSet{
            setNeedsDisplay()
        }
    }
    var animating = false{
        didSet{
            if animating{
                spinner.startAnimating()
                setNeedsDisplay()
            }else{
                spinner.stopAnimating()
                setNeedsDisplay()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit(){
        addSubview(spinner)
        sizeToFit()
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = .Gray
    }
   public override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, 0.25 * totalHeight - margin)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func sinCGFloat(angle:CGFloat)->CGFloat{
        let result = sinf(Float(angle))
        return CGFloat(result)
    }
    func cosCGFloat(angle:CGFloat)->CGFloat{
        let result = cosf(Float(angle))
        return CGFloat(result)
    }
    public override func drawRect(rect: CGRect) {
        //如果在Animating，则什么都不做
        if animating {
            super.drawRect(rect)
            return
        }
        let context = UIGraphicsGetCurrentContext()
        let centerX = rect.width/2.0
        let lineWidth = 2.5 - 1.0 * progress
        //上面圆的信息
        let upCenter = CGPointMake(centerX, (0.75 - 0.5 * progress) * totalHeight - margin)
        let upRadius = radius - radius * 0.5 * progress
        
        //下面圆的信息
        let downRadius:CGFloat = radius  - radius * 0.8 * progress
        let downCenter = CGPointMake(centerX, totalHeight - downRadius - margin)
    
        //偏移的角度
        let offSetAngle:CGFloat = CGFloat(M_PI_2 / 12.0)
        //计算上面圆的左/右的交点坐标
        let upP1 = CGPointMake(upCenter.x - upRadius * cosCGFloat(offSetAngle), upCenter.y + upRadius * sinCGFloat(offSetAngle))
        let upP2 = CGPointMake(upCenter.x + upRadius * cosCGFloat(offSetAngle), upCenter.y + upRadius * sinCGFloat(offSetAngle))

        //计算下面的圆左/右叫点坐标
        let downP1 = CGPointMake(downCenter.x - downRadius * cosCGFloat(offSetAngle), downCenter.y -  downRadius * sinCGFloat(offSetAngle))
        
        //计算Control Point
        let controPonintLeft = CGPointMake(downCenter.x - downRadius, (downCenter.y + upCenter.y)/2)
        let controPonintRight = CGPointMake(downCenter.x + downRadius, (downCenter.y + upCenter.y)/2)
        
        //实际绘制
        CGContextSetFillColorWithColor(context, elasticTintColor.CGColor)
        CGContextAddArc(context,upCenter.x,upCenter.y,upRadius,CGFloat(-M_PI)-offSetAngle,offSetAngle,0)
        CGContextMoveToPoint(context,upP1.x, upP1.y)
        CGContextAddQuadCurveToPoint(context, controPonintLeft.x,controPonintLeft.y,downP1.x, downP1.y)
        CGContextAddArc(context, downCenter.x, downCenter.y, downRadius,CGFloat(-M_PI) - offSetAngle,offSetAngle,1)
        CGContextAddQuadCurveToPoint(context, controPonintRight.x, controPonintRight.y, upP2.x, upP2.y)
        CGContextFillPath(context)
        
        //绘制箭头
        CGContextSetStrokeColorWithColor(context, arrowColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextAddArc(context, upCenter.x, upCenter.y, arrowRadius, 0, CGFloat(M_PI * 1.5), 0)
        CGContextStrokePath(context)
        
        CGContextSetFillColorWithColor(context, arrowColor.CGColor)
        CGContextSetLineWidth(context, 0.0)
        
        CGContextMoveToPoint(context, upCenter.x, upCenter.y - arrowRadius - lineWidth * 1.5)
        CGContextAddLineToPoint(context, upCenter.x, upCenter.y - arrowRadius + lineWidth * 1.5)
        CGContextAddLineToPoint(context, upCenter.x + lineWidth * 0.865 * 3, upCenter.y - arrowRadius)
        CGContextAddLineToPoint(context, upCenter.x, upCenter.y - arrowRadius - lineWidth * 1.5)
        CGContextFillPath(context)
        
    }
    override public func sizeToFit() {
        var width = frame.size.width
        if width < 30.0{
            width = 30.0
        }
        self.frame = CGRectMake(frame.origin.x, frame.origin.y,width, totalHeight)
    }
}