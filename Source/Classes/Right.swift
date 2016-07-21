//
//  Right.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//
import Foundation
import UIKit


public class DefaultRefreshRight:UIView,RefreshableLeftRight{
    public let imageView:UIImageView = UIImageView()
    public  let textLabel:UILabel  = UILabel().SetUp {
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
        textLabel.frame = CGRectMake(30,0,20,frame.size.height)
        textLabel.autoresizingMask = .FlexibleHeight
        textLabel.numberOfLines = 0
        imageView.frame = CGRectMake(0, 0,20, 20)
        imageView.center = CGPointMake(10,frame.size.height/2)
        let image = UIImage(named: "arrow_left", inBundle: NSBundle(forClass: DefaultRefreshHeader.self), compatibleWithTraitCollection: nil)
        imageView.image = image
        textDic[.scrollToAction] = PullToRefreshKitRightString.scrollToViewMore
        textDic[.releaseToAction] = PullToRefreshKitRightString.releaseToViewMore
        textLabel.text = textDic[.scrollToAction]
    }
   public  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RefreshableLeftRight Protocol  -
   public func distanceToRefresh() -> CGFloat {
        return PullToRefreshKitConst.defaultLeftWidth
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
   public func didCompleteEndRefershingAnimation() {
        imageView.transform = CGAffineTransformIdentity
        textLabel.text = textDic[.scrollToAction]
    }
   public  func didBeginRefreshing() {
        
    }
}

class RefreshRightContainer:UIView{
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
        self.frame = CGRectMake(attachedScrollView.contentSize.width,0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
    }
    deinit{
        removeObservers()
    }
    // MARK: - Private -
    private func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.Old,.New], context: nil)
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathContentSize, options:[.Old,.New] , context: nil)
    }
    private func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }

    func handleScrollOffSetChange(change: [String : AnyObject]?){
        if state == .Refreshing {
            return;
        }
        let offSetX = attachedScrollView.contentOffset.x
        let contentWidth = attachedScrollView.contentSize.width
        let contentInset = attachedScrollView.contentInset
        let scrollViewWidth = CGRectGetWidth(attachedScrollView.bounds)
        if attachedScrollView.dragging {
            let percent = (offSetX + scrollViewWidth - contentInset.left - contentWidth)/CGRectGetWidth(self.frame)
            self.delegate?.percentUpdateWhenNotRefreshing(percent)
            if state == .Idle && percent > 1.0 {
                self.state = .Pulling
            }else if state == .Pulling && percent <= 1.0{
                state = .Idle
            }
        }else if state == .Pulling{
            beginRefreshing()
        }
    }
    func handleContentSizeChange(change: [String : AnyObject]?){
        self.frame = CGRectMake(self.attachedScrollView.contentSize.width,0,self.frame.size.width,self.frame.size.height)
    }
    
    // MARK: - KVO -
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
        guard !self.hidden else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathContentSize {
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
    }
    
    
}