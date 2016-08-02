//
//  ElasticRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

public class ElasticRefreshHeader: UIView,RefreshableHeader {
    let control:ElasticRefreshControl
    public let textLabel:UILabel = UILabel(frame: CGRectMake(0,0,120,40))
    public let imageView:UIImageView = UIImageView(frame: CGRectZero)
    private var textDic = [RefreshKitHeaderText:String]()
    private let totalHegiht:CGFloat = 80.0
    override init(frame: CGRect) {
        control = ElasticRefreshControl(frame: frame)
        let adjustFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, totalHegiht)
        super.init(frame: adjustFrame)
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.whiteColor()
        imageView.sizeToFit()
        imageView.frame = CGRectMake(0, 0, 16, 16)
        textLabel.font = UIFont.systemFontOfSize(12)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.darkGrayColor()
        addSubview(control)
        addSubview(textLabel)
        addSubview(imageView)
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textLabel.text = textDic[.pullToRefresh]
    }
    public func setText(text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        control.frame = self.bounds
        imageView.center = CGPointMake(frame.width/2 - 40 - 20, totalHegiht * 0.75)
        textLabel.center = CGPointMake(frame.size.width/2, totalHegiht * 0.75);
    }
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let superView = newSuperview{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, superView.frame.size.width, self.frame.size.height)
        }
    }
    // MARK: - Refreshable Header -

    public func heightForRefreshingState() -> CGFloat {
        return totalHegiht/2.0
    }
    public func heightForFireRefreshing()->CGFloat{
        return totalHegiht
    }
    public func percentUpdateDuringScrolling(percent:CGFloat){
        self.control.animating = false
        if percent > 0.5 && percent <= 1.0{
            self.control.progress = (percent - 0.5)/0.5
        }else if percent <= 0.5{
            self.control.progress = 0.0
        }else{
            self.control.progress = 1.0
        }
    }
    public func didBeginRefreshingState() {
        self.control.animating = true
    }
    public func didBeginEndRefershingAnimation(result:RefreshResult) {
        switch result {
        case .Success:
            self.control.hidden = true
            imageView.hidden = false
            textLabel.hidden = false
            textLabel.text = textDic[.refreshSuccess]
            imageView.image = UIImage(named: "success", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        case .Failure:
            self.control.hidden = true
            imageView.hidden = false
            textLabel.hidden = false
            textLabel.text = textDic[.refreshFailure]
            imageView.image = UIImage(named: "failure", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        case .None:
            self.control.hidden = false
            imageView.hidden = true
            textLabel.hidden = true
            textLabel.text = textDic[.pullToRefresh]
            imageView.image = nil
        }
    }
    public func didCompleteEndRefershingAnimation(result:RefreshResult) {
        self.control.hidden = false
        self.imageView.hidden = true
        self.textLabel.hidden = true
        
    }

}