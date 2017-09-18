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
    case idle = 0
    case pulling = 1
    case refreshing = 2
    case willRefresh = 3
}
open class DefaultRefreshHeader:UIView,RefreshableHeader, Tintable {
    open let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    open let textLabel:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 140,height: 40))
    open let imageView:UIImageView = UIImageView(frame: CGRect.zero)
    open var durationWhenHide = 0.5
    fileprivate var textDic = [RefreshKitHeaderText:String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        addSubview(imageView);
        let image = UIImage(named: "arrow_down", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        imageView.image = image
        imageView.sizeToFit()
        imageView.becomeTintable()
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textAlignment = .center
        self.isHidden = true
        //Default text
        textDic[.pullToRefresh] = PullToRefreshKitHeaderString.pullDownToRefresh
        textDic[.releaseToRefresh] = PullToRefreshKitHeaderString.releaseToRefresh
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textDic[.refreshing] = PullToRefreshKitHeaderString.refreshing
        textLabel.text = textDic[.pullToRefresh]
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.center = CGPoint(x: frame.width/2 - 70 - 20, y: frame.size.height/2)
        spinner.center = imageView.center
        textLabel.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2);
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func setText(_ text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    // MARK: - Refreshable  -
    open func heightForRefreshingState() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
    public func percentUpdateDuringScrolling(_ percent: CGFloat) {
        self.isHidden = false
    }
    public func stateDidChanged(_ oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if oldState == RefreshHeaderState.idle && newState == RefreshHeaderState.pulling{
            textLabel.text = textDic[.releaseToRefresh]
            guard self.imageView.transform == CGAffineTransform.identity else{
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi+0.000001)
            })
        }
        if oldState == RefreshHeaderState.pulling && newState == RefreshHeaderState.idle {
            textLabel.text = textDic[.pullToRefresh]
            guard self.imageView.transform == CGAffineTransform(rotationAngle: -CGFloat.pi+0.000001)  else{
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        }
    }
    open func durationWhenEndRefreshing() -> Double {
        return durationWhenHide
    }
    open func didBeginEndRefershingAnimation(_ result:RefreshResult) {
        spinner.stopAnimating()
        imageView.transform = CGAffineTransform.identity
        imageView.isHidden = false
        switch result {
        case .success:
            textLabel.text = textDic[.refreshSuccess]
            imageView.image = UIImage(named: "success", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .failure:
            textLabel.text = textDic[.refreshFailure]
            imageView.image = UIImage(named: "failure", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .none:
            textLabel.text = textDic[.pullToRefresh]
            imageView.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        }
        imageView.becomeTintable()
    }
    open func didCompleteEndRefershingAnimation(_ result:RefreshResult) {
        textLabel.text = textDic[.pullToRefresh]
        self.isHidden = true
        imageView.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        imageView.becomeTintable()
    }
    open func didBeginRefreshingState() {
        self.isHidden = false
        textLabel.text = textDic[.refreshing]
        spinner.startAnimating()
        imageView.isHidden = true
    }
    
    // MARK: Tintable
    open func setThemeColor(themeColor: UIColor) {
        imageView.tintColor = themeColor
        textLabel.textColor = themeColor
        spinner.color = themeColor
    }
}

open class RefreshHeaderContainer:UIView{
    // MARK: - Propertys -
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    var originalInset:UIEdgeInsets?
    var durationOfEndRefreshing = 0.4
    weak var delegate:RefreshableHeader?
    fileprivate var currentResult:RefreshResult = .none
    fileprivate var _state:RefreshHeaderState = .idle
    fileprivate var insetTDelta:CGFloat = 0.0
    fileprivate var delayTimer:Timer?
    fileprivate var state:RefreshHeaderState{
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
            case .idle:
                guard oldValue == .refreshing else{
                    return
                }
                UIView.animate(withDuration: durationOfEndRefreshing, animations: {
                    var oldInset = self.attachedScrollView.contentInset
                    oldInset.top = oldInset.top + self.insetTDelta
                    self.attachedScrollView.contentInset = oldInset
                    
                    }, completion: { (finished) in
                        self.delegate?.didCompleteEndRefershingAnimation(self.currentResult)
                })
            case .refreshing:
                DispatchQueue.main.async(execute: {
                    let insetHeight = (self.delegate?.heightForRefreshingState())!
                    var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
                    if fireHeight == nil{
                        fireHeight = insetHeight
                    }
                    let offSetY = self.attachedScrollView.contentOffset.y
                    let topShowOffsetY = -1.0 * self.originalInset!.top
                    let normal2pullingOffsetY = topShowOffsetY - fireHeight
                    let currentOffset = self.attachedScrollView.contentOffset
                    UIView.animate(withDuration: 0.4, animations: {
                        let top = (self.originalInset?.top)! + insetHeight
                        var oldInset = self.attachedScrollView.contentInset
                        oldInset.top = top
                        self.attachedScrollView.contentInset = oldInset
                        if offSetY > normal2pullingOffsetY{ //手动触发
                            self.attachedScrollView.contentOffset = CGPoint(x: 0, y: -1.0 * top)
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
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = .flexibleWidth
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life circle -
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
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
    fileprivate func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.old,.new], context: nil)
    }
    fileprivate func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }
    func handleScrollOffSetChange(_ change: [NSKeyValueChangeKey : Any]?){
        let insetHeight = (self.delegate?.heightForRefreshingState())!
        var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
        if fireHeight == nil{
            fireHeight = insetHeight
        }
        if state == .refreshing {
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
        if attachedScrollView.isDragging {
            if state == .idle && offSetY < normal2pullingOffsetY {
                self.state = .pulling
            }else if state == .pulling && offSetY >= normal2pullingOffsetY{
                state = .idle
            }
        }else if state == .pulling{
            beginRefreshing()
            return
        }
        let percent = (topShowOffsetY - offSetY)/fireHeight
        //防止在结束刷新的时候，percent的跳跃
        if let oldOffset = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).cgPointValue{
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
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard self.isUserInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
    }
    // MARK: - API -
    func beginRefreshing(){
        if self.window != nil {
            self.state = .refreshing
        }else{
            if state != .refreshing{
                self.state = .willRefresh
            }
        }
    }
    @objc func updateStateToIdea(){
        self.state = .idle
        clearTimer()
    }
    func endRefreshing(_ result:RefreshResult,delay:TimeInterval = 0.0){
        self.delegate?.didBeginEndRefershingAnimation(result)
        self.delayTimer = Timer(timeInterval: delay, target: self, selector: #selector(RefreshHeaderContainer.updateStateToIdea), userInfo: nil, repeats: false)
        RunLoop.main.add(self.delayTimer!, forMode: RunLoopMode.commonModes)
    }
    func clearTimer(){
        if self.delayTimer != nil{
            self.delayTimer?.invalidate()
            self.delayTimer = nil
        }
    }
}



