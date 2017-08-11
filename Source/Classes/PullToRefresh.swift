//
//  PullToRefreshKit.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

@objc public enum RefreshResult:Int{
    /**
     *  刷新成功
     */
    case success = 200
    /**
     *  刷新失败
     */
    case failure = 400
    /**
     *  默认状态
     */
    case none = 0
}
@objc public protocol RefreshableHeader:class{
    /**
     在刷新状态的时候，距离顶部的距离
     */
    func heightForRefreshingState()->CGFloat
    
    /**
     进入刷新状态的回调，在这里将视图调整为刷新中
     */
    func didBeginRefreshingState()
    
    /**
       刷新结束，将要进行隐藏的动画，一般在这里告诉用户刷新的结果
     - parameter result: 刷新结果
     */
    func didBeginEndRefershingAnimation(_ result:RefreshResult)
    /**
       刷新结束，隐藏的动画结束，一般在这里把视图隐藏，各个参数恢复到最初状态
     
     - parameter result: 刷新结果
     */
    func didCompleteEndRefershingAnimation(_ result:RefreshResult)
    
    /**
     状态改变
     
     - parameter newState: 新的状态
     - parameter oldState: 老得状态
    */
    @objc optional func stateDidChanged(_ oldState:RefreshHeaderState, newState:RefreshHeaderState)
    /**
     触发刷新的距离，可选，如果没有实现，则默认触发刷新的距离就是 heightForRefreshingState
     */
    @objc optional func heightForFireRefreshing()->CGFloat
    
    /**
     不在刷新状态的时候，百分比回调，在这里你根据百分比来动态的调整你的刷新视图
     - parameter percent: 拖拽的百分比，比如一共距离是100，那么拖拽10的时候，percent就是0.1
     */
    @objc optional func percentUpdateDuringScrolling(_ percent:CGFloat)
    
    /**
     刷新结束，隐藏header的时间间隔，默认0.4s
     
     */
    @objc optional func durationWhenEndRefreshing()->Double
}

@objc public protocol RefreshableFooter:class{
    /**
     触发动作的距离，对于header/footer来讲，就是视图的高度；对于left/right来讲，就是视图的宽度
     */
    func heightForRefreshingState()->CGFloat
    /**
     不需要下拉加载更多的回调
     */
    func didUpdateToNoMoreData()
    /**
     重新设置到常态的回调
     */
    func didResetToDefault()
    /**
     结束刷新的回调
     */
    func didEndRefreshing()
    /**
     已经开始执行刷新逻辑，在一次刷新中，只会调用一次
     */
    func didBeginRefreshing()
    
    /**
     当Scroll触发刷新，这个方法返回是否需要刷新
     */
    func shouldBeginRefreshingWhenScroll()->Bool
}

public protocol RefreshableLeftRight:class{
    /**
     触发动作的距离，对于header/footer来讲，就是视图的高度；对于left/right来讲，就是视图的宽度
     */
    func heightForRefreshingState()->CGFloat
    /**
     已经开始执行刷新逻辑，在一次刷新中，只会调用一次
     */
    func didBeginRefreshing()
    /**
     结束刷新的回调
     */
    func didCompleteEndRefershingAnimation()
    /**
     拖动百分比变化的回调
     
     - parameter percent: 拖动百分比，大于0
     */
    func percentUpdateDuringScrolling(_ percent:CGFloat)
}


public protocol SetUp {}
public extension SetUp where Self: AnyObject {
    //Add @noescape to make sure that closure is sync and can not be stored
    @discardableResult
    public func SetUp(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: SetUp {}

//Header
public extension UIScrollView{
    @discardableResult
    public func setUpHeaderRefresh(_ action:@escaping ()->())->DefaultRefreshHeader{
        let header = DefaultRefreshHeader(frame:CGRect(x: 0,y: 0,width: self.frame.width,height: PullToRefreshKitConst.defaultHeaderHeight))
        return setUpHeaderRefresh(header, action: action)
    }
    @discardableResult
    public func setUpHeaderRefresh<T:UIView>(_ header:T,action:@escaping ()->())->T where T:RefreshableHeader{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        
        let containFrame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        let containComponent = RefreshHeaderContainer(frame: containFrame)
        if let endDuration = header.durationWhenEndRefreshing?(){
            containComponent.durationOfEndRefreshing = endDuration
        }
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        
        containComponent.delegate = header
        header.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let bounds = CGRect(x: 0,y: containFrame.height - header.frame.height,width: self.frame.width,height: header.frame.height)
        header.frame = bounds
        containComponent.addSubview(header)
        return header
    }
    public func beginHeaderRefreshing(){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.beginRefreshing()
        
    }
    public  func endHeaderRefreshing(_ result:RefreshResult = .none,delay:Double = 0.0){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.endRefreshing(result,delay: delay)
    }
}

//Footer
public extension UIScrollView{
    @discardableResult
    public func setUpFooterRefresh(_ action:@escaping ()->())->DefaultRefreshFooter{
        let footer = DefaultRefreshFooter(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: PullToRefreshKitConst.defaultFooterHeight))
        return setUpFooterRefresh(footer, action: action)
    }
    @discardableResult
    public func setUpFooterRefresh<T:UIView>(_ footer:T,action:@escaping ()->())->T where T:RefreshableFooter{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let frame = CGRect(x: 0,y: 0,width: self.frame.width, height: PullToRefreshKitConst.defaultFooterHeight)
        
        let containComponent = RefreshFooterContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        
        containComponent.delegate = footer
        footer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        footer.frame = containComponent.bounds
        containComponent.addSubview(footer)
        return footer
    }
    public func beginFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.beginRefreshing()
    }
    public func endFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    public func setFooterNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    public func resetFooterToDefault(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.resetToDefault()
    }
    public  func endFooterRefreshingWithNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
        footer?.updateToNoMoreData()
    }
}

//Left
extension UIScrollView{
    @discardableResult
    public func setUpLeftRefresh(_ action:@escaping ()->())->DefaultRefreshLeft{
        let left = DefaultRefreshLeft(frame: CGRect(x: 0,y: 0,width: PullToRefreshKitConst.defaultLeftWidth, height: self.frame.height))
        return setUpLeftRefresh(left, action: action)
    }
    @discardableResult
    public func setUpLeftRefresh<T:UIView>(_ left:T,action:@escaping ()->())->T where T:RefreshableLeftRight{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.leftTag)
        oldContain?.removeFromSuperview()
        let frame = CGRect(x: -1.0 * PullToRefreshKitConst.defaultLeftWidth,y: 0,width: PullToRefreshKitConst.defaultLeftWidth, height: self.frame.height)
        let containComponent = RefreshLeftContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.leftTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        
        containComponent.delegate = left
        left.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        left.frame = containComponent.bounds
        containComponent.addSubview(left)
        return left
    }
}
//Right
extension UIScrollView{
    @discardableResult
    public  func setUpRightRefresh(_ action:@escaping ()->())->DefaultRefreshRight{
        let right = DefaultRefreshRight(frame: CGRect(x: 0 ,y: 0 ,width: PullToRefreshKitConst.defaultLeftWidth ,height: self.frame.height ))
        return setUpRightRefresh(right, action: action)
    }
    @discardableResult
    public func setUpRightRefresh<T:UIView>(_ right:T,action:@escaping ()->())->T where T:RefreshableLeftRight{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.rightTag)
        oldContain?.removeFromSuperview()
        let frame = CGRect(x: 0 ,y: 0 ,width: PullToRefreshKitConst.defaultLeftWidth ,height: self.frame.height )
        let containComponent = RefreshRightContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.rightTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        
        containComponent.delegate = right
        right.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        right.frame = containComponent.bounds
        containComponent.addSubview(right)
        return right
    }
}
