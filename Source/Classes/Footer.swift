//
//  Footer.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit

class DefaultRefreshFooter:UIView,RefreshableFooter{
    let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let textLabel:UILabel = UILabel(frame: CGRectMake(0,0,100,40)).SetUp {
        $0.font = UIFont.systemFontOfSize(14)
        $0.textAlignment = .Center
        $0.text = "上拉加载更多数据"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        spinner.center = CGPointMake(frame.width/2 - 50 - 20, frame.size.height/2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Refreshable  -
    func distanceToRefresh() -> CGFloat {
        return defaultFooterHeight
    }
    func didBeginRefreshing() {
        textLabel.text = "正在加载中...";
        spinner.startAnimating()
    }
    func didEndRefreshing() {
        textLabel.text = "上拉加载更多数据"
        spinner.stopAnimating()
    }
    func didUpdateToNoMoreData(){
        textLabel.text = "数据加载完毕"
    }
    func didResetToDefault() {
        textLabel.text = "上拉加载更多数据"
    }
}
class RefreshFooterContainer:UIView{
// MARK: - Propertys -
    enum RefreshFooterState {
        case Idle
        case Refreshing
        case WillRefresh
        case NoMoreData
    }
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    weak var delegate:RefreshableFooter?
    private var _state:RefreshFooterState = .Idle
    var state:RefreshFooterState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            _state =  newValue
            if newValue == .Refreshing{
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.didBeginRefreshing()
                    self.refreshAction?()
                })
            }else if newValue == .NoMoreData{
                self.delegate?.didUpdateToNoMoreData()
            }else if newValue == .Idle{
                self.delegate?.didResetToDefault()
            }
        }
    }
// MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit(){
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.clearColor()
        self.autoresizingMask = .FlexibleWidth
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - Life circle -
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard newSuperview != nil else{ //remove from superview
            if !self.hidden{
                var inset = attachedScrollView.contentInset
                inset.bottom = inset.bottom - CGRectGetHeight(self.frame)
                attachedScrollView.contentInset = inset
            }
            return
        }
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        if !self.hidden {
            var contentInset = attachedScrollView.contentInset
            contentInset.bottom = contentInset.bottom + CGRectGetHeight(self.frame)
            attachedScrollView.contentInset = contentInset
        }
        self.frame = CGRectMake(0,attachedScrollView.contentSize.height,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        addObservers()
    }
    deinit{
        removeObservers()
    }
    
// MARK: - Private -
    private func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:KPathOffSet, options: [.Old,.New], context: nil)
        attachedScrollView?.addObserver(self, forKeyPath:KPathContentSize, options:[.Old,.New] , context: nil)
        attachedScrollView?.panGestureRecognizer.addObserver(self, forKeyPath:KPathPanState, options:[.Old,.New] , context: nil)
    }
    private func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: KPathContentSize,context: nil)
        attachedScrollView?.removeObserver(self, forKeyPath: KPathOffSet,context: nil)
        attachedScrollView?.panGestureRecognizer.removeObserver(self, forKeyPath: KPathPanState,context: nil)
    }
    func handleScrollOffSetChange(change: [String : AnyObject]?){
        if state != .Idle && self.frame.origin.y != 0{
            return
        }
        let insetTop = attachedScrollView.contentInset.top
        let contentHeight = attachedScrollView.contentSize.height
        let scrollViewHeight = attachedScrollView.frame.size.height
        if insetTop + contentHeight > scrollViewHeight{
            let offSetY = attachedScrollView.contentOffset.y
            if offSetY > self.frame.origin.y - scrollViewHeight + attachedScrollView.contentInset.bottom{
                let oldOffset = change?[NSKeyValueChangeOldKey]?.CGPointValue()
                let newOffset = change?[NSKeyValueChangeNewKey]?.CGPointValue()
                guard newOffset?.y > oldOffset?.y else{
                    return
                }
                beginRefreshing()
            }
        }
    }
    func handlePanStateChange(change: [String : AnyObject]?){
        guard state == .Idle else{
            return
        }
        if attachedScrollView.panGestureRecognizer.state == .Ended {
            let scrollInset = attachedScrollView.contentInset
            let scrollOffset = attachedScrollView.contentOffset
            let contentSize = attachedScrollView.contentSize
            if scrollInset.top + contentSize.height <= CGRectGetHeight(attachedScrollView.frame){
                if scrollOffset.y >= -1 * scrollInset.top {
                    beginRefreshing()
                }
            }else{
                if scrollOffset.y > contentSize.height + scrollInset.bottom - CGRectGetHeight(attachedScrollView.frame) {
                    beginRefreshing()
                }
            }
        }
    }
    func handleContentSizeChange(change: [String : AnyObject]?){
        self.frame = CGRectMake(0,self.attachedScrollView.contentSize.height,self.frame.size.width,self.frame.size.height)
    }
// MARK: - KVO -
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else{
            return;
        }
        if keyPath == KPathOffSet {
            handleScrollOffSetChange(change)
        }
        guard !self.hidden else{
            return;
        }
        if keyPath == KPathPanState{
            handlePanStateChange(change)
        }
        if keyPath == KPathContentSize {
            handleContentSizeChange(change)
        }
    }
    // MARK: - API -
    func beginRefreshing(){
        if self.window != nil {
            self.state = .Refreshing
        }else{
            if state != .Refreshing{
                self.state = .WillRefresh
            }
        }
    }
    func endRefreshing(){
        self.state = .Idle
        self.delegate?.didEndRefreshing()
    }
    func resetToDefault(){
        self.state = .Idle
    }
    func updateToNoMoreData(){
        self.state = .NoMoreData
    }
}

