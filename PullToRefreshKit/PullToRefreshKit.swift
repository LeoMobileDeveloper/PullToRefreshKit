//
//  PullToRefreshKit.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

enum RefreshResult{
    case Success
    case Failure
    case Error
    case None
}
protocol RefreshAble:class{
    func distanceToRefresh()->CGFloat
    func didBeginRefreshing()
}
protocol RefreshableHeader:RefreshAble{
    func percentageChangedDuringDragging(percent:CGFloat)
    func willBeginRefreshing()
    func willEndRefreshing(result:RefreshResult)
    func didEndRefreshing(result:RefreshResult)
}

protocol RefreshableFooter:RefreshAble{
    func didUpdateToNoMoreData()
    func didResetToDefault()
    func didEndRefreshing()
}

protocol RefreshableLeftRight:RefreshAble{
    func didEndRefreshing()
    func percentageChangedDuringDragging(percent:CGFloat)
}

//Easy to setup

public protocol SetUp {}
extension SetUp where Self: AnyObject {
    //Add @noescape to make sure that closure is sync and can not be stored
    public func SetUp(@noescape closure: Self -> Void) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: SetUp {}

//Header
extension UIScrollView{
    func setUpHeaderRefresh(action:()->())->DefaultRefreshHeader{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(0,-1 * PullToRefreshKitConst.defaultHeaderHeight,CGRectGetWidth(self.frame), PullToRefreshKitConst.defaultHeaderHeight)
        let containComponent = RefreshHeaderContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        
        let header = DefaultRefreshHeader(frame: containComponent.bounds)
        containComponent.delegate = header
        header.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        containComponent.addSubview(header)
        return header
    }
    
    func setUpHeaderRefresh<T:UIView where T:RefreshableHeader>(componnet:T,action:()->()){
        
    }
    func beginHeaderRefreshing(){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.beginRefreshing()
        
    }
    func endHeaderRefreshing(result:RefreshResult = .None){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.endRefreshing(result)
    }
}
//Footer
extension UIScrollView{
    func setUpFooterRefresh(action:()->())->DefaultRefreshFooter{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(0,0,CGRectGetWidth(self.frame), PullToRefreshKitConst.defaultFooterHeight)
        
        let containComponent = RefreshFooterContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        let footer = DefaultRefreshFooter(frame: containComponent.bounds)
        containComponent.delegate = footer
        footer.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        containComponent.addSubview(footer)
        return footer
    }
    func setUpFooterRefresh<T:UIView where T:RefreshableFooter>(component:T,action:()->()){
     
    }
    func beginFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshHeaderContainer
        footer?.beginRefreshing()
    }
    func endFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    func setFooterNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    func resetFooterToDefault(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.resetToDefault()
    }
    func endFooterRefreshingWithNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
        footer?.updateToNoMoreData()
    }
}

//Left
extension UIScrollView{
    func setUpLeftRefresh(action:()->()){
        let oldContain = self.viewWithTag(PullToRefreshKitConst.leftTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake( -1.0 * PullToRefreshKitConst.defaultLeftWidth,0,PullToRefreshKitConst.defaultLeftWidth, CGRectGetHeight(self.frame))
        let containComponent = RefreshLeftContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.leftTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        let left = DefaultRefreshLeft(frame: containComponent.bounds)
        containComponent.delegate = left
        left.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        containComponent.addSubview(left)
    }
    func setUpLeftRefresh<T:UIView where T:RefreshableLeftRight>(component:T,action:()->()){
        
    }
}
//Right
extension UIScrollView{
    func setUpRightRefresh(action:()->()){
        let oldContain = self.viewWithTag(PullToRefreshKitConst.rightTag)
        oldContain?.removeFromSuperview()
        let frame = CGRectMake(0 ,0 ,PullToRefreshKitConst.defaultLeftWidth ,CGRectGetHeight(self.frame) )
        let containComponent = RefreshRightContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.rightTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, atIndex: 0)
        
        let right = DefaultRefreshRight(frame: containComponent.bounds)
        containComponent.delegate = right
        right.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        containComponent.addSubview(right)
    }
    func setUpRightRefresh<T:UIView where T:RefreshableLeftRight>(component:T,action:()->()){
        
    }
}
