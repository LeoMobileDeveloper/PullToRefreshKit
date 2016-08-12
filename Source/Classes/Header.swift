//
//  PullToRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

public enum RefreshKitHeaderText{
    case pullToRefresh
    case releaseToRefresh
    case refreshSuccess
    case refreshFailure
    case refreshing
}
/**
 Header所处的状态
 
 - Idle:        最初
 - Pulling:     下拉
 - Refreshing:  正在刷新中
 - WillRefresh: 将要刷新
 */
@objc public enum RefreshHeaderState:Int{
    case Idle = 0
    case Pulling = 1
    case Refreshing = 2
    case WillRefresh = 3
}
public class DefaultRefreshHeader:UIView,RefreshableHeader{
    public let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    public let textLabel:UILabel = UILabel(frame: CGRectMake(0,0,140,40))
    public let imageView:UIImageView = UIImageView(frame: CGRectZero)
    public var durationWhenHide = 0.5
    private var textDic = [RefreshKitHeaderText:String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        addSubview(imageView);
        let image = UIImage(named: "arrow_down", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        imageView.image = image
        imageView.sizeToFit()
        imageView.frame = CGRectMake(0, 0, 20, 20)
        imageView.center = CGPointMake(frame.width/2 - 70 - 20, frame.size.height/2)
        spinner.center = imageView.center
        
        textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textAlignment = .Center
        self.hidden = true
        //Default text
        textDic[.pullToRefresh] = PullToRefreshKitHeaderString.pullDownToRefresh
        textDic[.releaseToRefresh] = PullToRefreshKitHeaderString.releaseToRefresh
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textDic[.refreshing] = PullToRefreshKitHeaderString.refreshing
        textLabel.text = textDic[.pullToRefresh]
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setText(text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    // MARK: - Refreshable  -
    public func heightForRefreshingState() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
    public func percentUpdateDuringScrolling(percent:CGFloat){
        self.hidden = !(percent > 0.0)
        if percent > 1.0{
            textLabel.text = textDic[.releaseToRefresh]
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformIdentity)  else{
                return
            }
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001))
            })
        }
        if percent <= 1.0{
            textLabel.text = textDic[.pullToRefresh]
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001)))  else{
                return
            }
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
    }
    public func durationWhenEndRefreshing() -> Double {
        return durationWhenHide
    }
    public func didBeginEndRefershingAnimation(result:RefreshResult) {
        spinner.stopAnimating()
        imageView.transform = CGAffineTransformIdentity
        imageView.hidden = false
        switch result {
        case .Success:
            textLabel.text = textDic[.refreshSuccess]
            imageView.image = UIImage(named: "success", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        case .Failure:
            textLabel.text = textDic[.refreshFailure]
            imageView.image = UIImage(named: "failure", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        case .None:
            textLabel.text = textDic[.pullToRefresh]
            imageView.image = UIImage(named: "arrow_down", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        }
    }
    public func didCompleteEndRefershingAnimation(result:RefreshResult) {
        textLabel.text = textDic[.pullToRefresh]
        self.hidden = true
        imageView.image = UIImage(named: "arrow_down", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
    }
    public func didBeginRefreshingState() {
        self.hidden = false
        textLabel.text = textDic[.refreshing]
        spinner.startAnimating()
        imageView.hidden = true
    }
}

public class RefreshHeaderContainer:UIView{
    // MARK: - Propertys -
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    var originalInset:UIEdgeInsets?
    var durationOfEndRefreshing = 0.4
    weak var delegate:RefreshableHeader?
    private var currentResult:RefreshResult = .None
    private var _state:RefreshHeaderState = .Idle
    private var insetTDelta:CGFloat = 0.0
    private var delayTimer:NSTimer?
    private var state:RefreshHeaderState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            self.delegate?.stateDidChanged?(_state,newState: newValue)
            let oldValue = _state
            _state =  newValue
            switch newValue {
            case .Idle:
                guard oldValue == .Refreshing else{
                    return
                }
                UIView.animateWithDuration(durationOfEndRefreshing, animations: {
                    var oldInset = self.attachedScrollView.contentInset
                    oldInset.top = oldInset.top + self.insetTDelta
                    self.attachedScrollView.contentInset = oldInset
                    
                    }, completion: { (finished) in
                        self.delegate?.didCompleteEndRefershingAnimation(self.currentResult)
                })
            case .Refreshing:
                dispatch_async(dispatch_get_main_queue(), {
                    let insetHeight = (self.delegate?.heightForRefreshingState())!
                    var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
                    if fireHeight == nil{
                        fireHeight = insetHeight
                    }
                    let offSetY = self.attachedScrollView.contentOffset.y
                    let topShowOffsetY = -1.0 * self.originalInset!.top
                    let normal2pullingOffsetY = topShowOffsetY - fireHeight
                    let currentOffset = self.attachedScrollView.contentOffset
                    UIView.animateWithDuration(0.4, animations: {
                        let top = (self.originalInset?.top)! + insetHeight
                        var oldInset = self.attachedScrollView.contentInset
                        oldInset.top = top
                        self.attachedScrollView.contentInset = oldInset
                        if offSetY > normal2pullingOffsetY{ //手动触发
                            self.attachedScrollView.contentOffset = CGPointMake(0, -1.0 * top)
                        }else{//release，防止跳动
                            self.attachedScrollView.contentOffset = currentOffset
                        }
                        }, completion: { (finsihed) in
                            self.refreshAction?()
                    })
                    self.delegate?.percentUpdateDuringScrolling?(1.0)
                    self.delegate?.didBeginRefreshingState()
                })
            default:
                break
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
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life circle -
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        originalInset = attachedScrollView?.contentInset
        addObservers()
    }
    deinit{
        clearTimer()
        removeObservers()
    }
    // MARK: - Private -
    private func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.Old,.New], context: nil)
    }
    private func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }
    func handleScrollOffSetChange(change: [String : AnyObject]?){
        let insetHeight = (self.delegate?.heightForRefreshingState())!
        var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
        if fireHeight == nil{
            fireHeight = insetHeight
        }
        if state == .Refreshing {
//Refer from here https://github.com/CoderMJLee/MJRefresh/blob/master/MJRefresh/Base/MJRefreshHeader.m, thanks to this lib again
            guard self.window != nil else{
                return
            }
            let offset = attachedScrollView.contentOffset
            let inset = originalInset!
            var insetT = -1 * offset.y > inset.top ? (-1 * offset.y):inset.top
            insetT = insetT > insetHeight + inset.top ? insetHeight + inset.top:insetT
            var oldInset = attachedScrollView.contentInset
            oldInset.top = insetT
            attachedScrollView.contentInset = oldInset
            insetTDelta = inset.top - insetT
            return;
        }
        
        originalInset =  attachedScrollView.contentInset
        let offSetY = attachedScrollView.contentOffset.y
        let topShowOffsetY = -1.0 * originalInset!.top
        guard offSetY <= topShowOffsetY else{
            return
        }
        let normal2pullingOffsetY = topShowOffsetY - fireHeight
        if attachedScrollView.dragging {
            if state == .Idle && offSetY < normal2pullingOffsetY {
                self.state = .Pulling
            }else if state == .Pulling && offSetY >= normal2pullingOffsetY{
                state = .Idle
            }
        }else if state == .Pulling{
            beginRefreshing()
            return
        }
        let percent = (topShowOffsetY - offSetY)/fireHeight
        //防止在结束刷新的时候，percent的跳跃
        if let oldOffset = change?[NSKeyValueChangeOldKey]?.CGPointValue(){
            let oldPercent = (topShowOffsetY - oldOffset.y)/fireHeight
            if oldPercent >= 1.0 && percent == 0.0{
                return
            }else{
                self.delegate?.percentUpdateDuringScrolling?(percent)
            }
        }else{
            self.delegate?.percentUpdateDuringScrolling?(percent)
        }
    }
    // MARK: - KVO -
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
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
    func updateStateToIdea(){
        self.state = .Idle
        clearTimer()
    }
    func endRefreshing(result:RefreshResult,delay:NSTimeInterval = 0.0){
        self.delegate?.didBeginEndRefershingAnimation(result)
        self.delayTimer = NSTimer(timeInterval: delay, target: self, selector: #selector(RefreshHeaderContainer.updateStateToIdea), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.delayTimer!, forMode: NSRunLoopCommonModes)
    }
    func clearTimer(){
        if self.delayTimer != nil{
            self.delayTimer?.invalidate()
            self.delayTimer = nil
        }
    }
}



