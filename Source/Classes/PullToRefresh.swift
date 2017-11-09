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
        if let endDuration = refrehser.durationWhenEndRefreshing?(){
            containComponent.durationOfEndRefreshing = endDuration
        }
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        containComponent.delegate = refrehser
        refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let bounds = CGRect(x: 0,y: containFrame.height - refrehser.frame.height,width: self.frame.width,height: refrehser.frame.height)
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
        let containComponent = RefreshFooterContainer(frame: refrehser.bounds)
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
        
    }
    
    public func removeSideRefresh(at destination:SideRefreshDestination){
        
    }
}
