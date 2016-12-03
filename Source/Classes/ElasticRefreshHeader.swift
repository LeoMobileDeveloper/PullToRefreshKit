//
//  ElasticRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

open class ElasticRefreshHeader: UIView,RefreshableHeader {
    let control:ElasticRefreshControl
    open let textLabel:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 120,height: 40))
    open let imageView:UIImageView = UIImageView(frame: CGRect.zero)
    fileprivate var textDic = [RefreshKitHeaderText:String]()
    fileprivate let totalHegiht:CGFloat = 80.0
    override init(frame: CGRect) {
        control = ElasticRefreshControl(frame: frame)
        let adjustFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: totalHegiht)
        super.init(frame: adjustFrame)
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.white
        imageView.sizeToFit()
        imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.darkGray
        addSubview(control)
        addSubview(textLabel)
        addSubview(imageView)
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textLabel.text = textDic[.pullToRefresh]
    }
    open func setText(_ text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        control.frame = self.bounds
        imageView.center = CGPoint(x: frame.width/2 - 40 - 40, y: totalHegiht * 0.75)
        textLabel.center = CGPoint(x: frame.size.width/2, y: totalHegiht * 0.75);
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let superView = newSuperview{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: superView.frame.size.width, height: self.frame.size.height)
        }
    }
    // MARK: - Refreshable Header -

    open func heightForRefreshingState() -> CGFloat {
        return totalHegiht/2.0
    }
    open func heightForFireRefreshing()->CGFloat{
        return totalHegiht
    }
    open func percentUpdateDuringScrolling(_ percent:CGFloat){
        self.control.animating = false
        if percent > 0.5 && percent <= 1.0{
            self.control.progress = (percent - 0.5)/0.5
        }else if percent <= 0.5{
            self.control.progress = 0.0
        }else{
            self.control.progress = 1.0
        }
    }
    open func didBeginRefreshingState() {
        self.control.animating = true
    }
    open func didBeginEndRefershingAnimation(_ result:RefreshResult) {
        switch result {
        case .success:
            self.control.isHidden = true
            imageView.isHidden = false
            textLabel.isHidden = false
            textLabel.text = textDic[.refreshSuccess]
            imageView.image = UIImage(named: "success", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .failure:
            self.control.isHidden = true
            imageView.isHidden = false
            textLabel.isHidden = false
            textLabel.text = textDic[.refreshFailure]
            imageView.image = UIImage(named: "failure", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .none:
            self.control.isHidden = false
            imageView.isHidden = true
            textLabel.isHidden = true
            textLabel.text = textDic[.pullToRefresh]
            imageView.image = nil
        }
    }
    open func didCompleteEndRefershingAnimation(_ result:RefreshResult) {
        self.control.isHidden = false
        self.imageView.isHidden = true
        self.textLabel.isHidden = true
        
    }

}
