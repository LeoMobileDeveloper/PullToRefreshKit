//
//  PullToRefreshKit.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

// MARK: - Header API  -

@objc public enum RefreshResult:Int{
    case success = 200
    case failure = 400
    case none = 0
}

public enum HeaderRefresherState {
    case refreshing //刷新中
    case normal(RefreshResult,TimeInterval)//正常状态
    case removed //移除
}

public extension UIScrollView{
    
    public func configRefreshHeader<T:UIView>(with refrehser:T,
                                              action:@escaping ()->()) where T: RefreshableHeader{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        let containFrame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        let containComponent = RefreshHeaderContainer(frame: containFrame)
        if let endDuration = refrehser.durationOfHideAnimation?(){
            containComponent.durationOfEndRefreshing = endDuration
        }
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        containComponent.delegate = refrehser
        refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let refreshHeight = refrehser.heightForHeader()
        let bounds = CGRect(x: 0,y: containFrame.height - refreshHeight,width: self.frame.width,height: refreshHeight)
        refrehser.frame = bounds
        containComponent.addSubview(refrehser)
    }
    
    public func switchRefreshHeader(to state:HeaderRefresherState){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        switch state {
        case .refreshing:
            header?.beginRefreshing()
        case .normal(let result, let delay):
            header?.endRefreshing(result,delay: delay)
        case .removed:
            header?.removeFromSuperview()
        }
    }
}

// MARK: - Footer API  -

public enum FooterRefresherState {
    case refreshing //刷新中
    case normal //正常状态，转换到这个状态会结束刷新
    case noMoreData //没有数据，转换到这个状态会结束刷新
    case removed //移除
}


public extension UIScrollView{
    public func configRefreshFooter<T:UIView>(with refrehser:T,
                                              action:@escaping ()->()) where T: RefreshableFooter{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let containComponent = RefreshFooterContainer(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: refrehser.heightForFooter()))
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        containComponent.delegate = refrehser
        refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        refrehser.frame = containComponent.bounds
        containComponent.addSubview(refrehser)
    }
    
    public func switchRefreshFooter(to state:FooterRefresherState){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        switch state {
            
        case .refreshing:
            footer?.beginRefreshing()
        case .normal:
            footer?.endRefreshing()
            footer?.resetToDefault()
        case .noMoreData:
            footer?.endRefreshing()
            footer?.updateToNoMoreData()
        case .removed:
            footer?.removeFromSuperview()
        }
    }
}


// MARK: - Left & Right API  -

public enum SideRefreshDestination {
    case left,right
}

public extension UIScrollView{
    public func configSideRefresh<T:UIView>(with refrehser:T,
                                            at destination:SideRefreshDestination,
                                            action:@escaping ()->()) where T: RefreshableLeftRight{
        switch destination {
            case .left:
                let oldContain = self.viewWithTag(PullToRefreshKitConst.leftTag)
                oldContain?.removeFromSuperview()
                let frame = CGRect(x: -1.0 * refrehser.frame.size.width,
                                   y: 0.0,
                                   width: refrehser.widthForComponent(),
                                   height: self.frame.height)
                let containComponent = RefreshLeftContainer(frame: frame)
                containComponent.tag = PullToRefreshKitConst.leftTag
                containComponent.refreshAction = action
                self.insertSubview(containComponent, at: 0)
                containComponent.delegate = refrehser
                refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                refrehser.frame = containComponent.bounds
                containComponent.addSubview(refrehser)
            case .right:
                let oldContain = self.viewWithTag(PullToRefreshKitConst.rightTag)
                oldContain?.removeFromSuperview()
                let frame = CGRect(x: 0 ,
                                   y: 0 ,
                                   width: refrehser.frame.size.width ,
                                   height: self.frame.height)
                let containComponent = RefreshRightContainer(frame: frame)
                containComponent.tag = PullToRefreshKitConst.rightTag
                containComponent.refreshAction = action
                self.insertSubview(containComponent, at: 0)
                
                containComponent.delegate = refrehser
                refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                refrehser.frame = containComponent.bounds
                containComponent.addSubview(refrehser)
        }
    }
    
    public func removeSideRefresh(at destination:SideRefreshDestination){
        switch destination {
        case .left:
            let oldContain = self.viewWithTag(PullToRefreshKitConst.leftTag)
            oldContain?.removeFromSuperview()
        case .right:
            let oldContain = self.viewWithTag(PullToRefreshKitConst.rightTag)
            oldContain?.removeFromSuperview()
        }
    }
}
