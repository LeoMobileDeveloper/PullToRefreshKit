//
//  Left.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

public enum RefreshKitLeftRightText{
    case scrollToAction
    case releaseToAction
}

public class DefaultRefreshLeft:UIView,RefreshableLeftRight{
    public let imageView:UIImageView = UIImageView()
    public let textLabel:UILabel  = UILabel().SetUp {
        $0.font = UIFont.systemFontOfSize(14)
    }
    private var textDic = [RefreshKitLeftRightText:String]()
    
    /**
     You can only call this function before pull
     */
    public func setText(text:String,mode:RefreshKitLeftRightText){
        textDic[mode] = text
        textLabel.text = textDic[.scrollToAction]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(textLabel)
        textLabel.frame = CGRectMake(10,0,20,frame.size.height)
        textLabel.autoresizingMask = .FlexibleHeight
        textLabel.numberOfLines = 0
        imageView.frame = CGRectMake(0, 0,20, 20)
        imageView.center = CGPointMake(40,frame.size.height/2)
        let image = UIImage(named: "arrow_right", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        imageView.image = image
        textDic[.scrollToAction] = PullToRefreshKitLeftString.scrollToClose
        textDic[.releaseToAction] = PullToRefreshKitLeftString.releaseToClose
        textLabel.text = textDic[.scrollToAction]
    }
   public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - RefreshableLeftRight Protocol  -
   public func distanceToRefresh() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
   public func percentUpdateWhenNotRefreshing(percent:CGFloat){
        if percent > 1.0{
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformIdentity)  else{
                return
            }
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001))
            })
            textLabel.text = textDic[.releaseToAction]
        }
        if percent <= 1.0{
            guard CGAffineTransformEqualToTransform(self.imageView.transform, CGAffineTransformMakeRotation(CGFloat(-M_PI+0.000001)))  else{
                return
            }
            textLabel.text = textDic[.scrollToAction]
            UIView.animateWithDuration(0.4, animations: {
                self.imageView.transform = CGAffineTransformIdentity
            })
        }
    }
   public func didBeginRefreshing() {

    }
   public func didCompleteEndRefershingAnimation() {
        textLabel.text = textDic[.scrollToAction]
    }
}

class RefreshLeftContainer:UIView{
    // MARK: - Propertys -
    enum RefreshHeaderState {
        case Idle
        case Pulling
        case Refreshing
        case WillRefresh
    }
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    weak var delegate:RefreshableLeftRight?
    private var _state:RefreshHeaderState = .Idle
    var state:RefreshHeaderState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            _state =  newValue
            switch newValue {
            case .Refreshing:
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.didBeginRefreshing()
                    self.refreshAction?()
                    self.endRefreshing()
                    self.delegate?.didCompleteEndRefershingAnimation()
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
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        addObservers()
    }
    deinit{
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
        if state == .Refreshing {
            return;
        }
        let offSetX = attachedScrollView.contentOffset.x
        let topShowOffsetX = -1.0 * attachedScrollView.contentInset.left
        guard offSetX <= topShowOffsetX else{
            return
        }
        let normal2pullingOffsetX = topShowOffsetX - self.frame.size.width
        let percent = (topShowOffsetX - offSetX)/self.frame.size.width
        if attachedScrollView.dragging {
            self.delegate?.percentUpdateWhenNotRefreshing(percent)
            if state == .Idle && offSetX < normal2pullingOffsetX {
                self.state = .Pulling
            }else if state == .Pulling && offSetX >= normal2pullingOffsetX{
                state = .Idle
            }
        }else if state == .Pulling{
            beginRefreshing()
        }
    }
    // MARK: - KVO -
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
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
                ()
            }
        }
    }
    func endRefreshing(){
        self.state = .Idle
    }

    
}