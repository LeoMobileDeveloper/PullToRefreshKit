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
@objcMembers
open class DefaultRefreshLeft: UIView, RefreshableLeftRight, Tintable {
    open let imageView:UIImageView = UIImageView()
    open let textLabel:UILabel  = UILabel().SetUp {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    fileprivate var textDic = [RefreshKitLeftRightText:String]()
    
    /**
     You can only call this function before pull
     */
    open func setText(_ text:String,mode:RefreshKitLeftRightText){
        textDic[mode] = text
        textLabel.text = textDic[.scrollToAction]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(textLabel)
        textLabel.frame = CGRect(x: 10,y: 0,width: 20,height: frame.size.height)
        textLabel.autoresizingMask = .flexibleHeight
        textLabel.numberOfLines = 0
        imageView.frame = CGRect(x: 0, y: 0,width: 20, height: 20)
        let image = UIImage(named: "arrow_right", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        imageView.image = image
        imageView.becomeTintable()
        textDic[.scrollToAction] = PullToRefreshKitLeftString.scrollToClose
        textDic[.releaseToAction] = PullToRefreshKitLeftString.releaseToClose
        textLabel.text = textDic[.scrollToAction]
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 10,y: 0,width: 20,height: frame.size.height)
        imageView.center = CGPoint(x: 40,y: frame.size.height/2)
    }
// MARK: - RefreshableLeftRight Protocol  -
   open func heightForRefreshingState() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
   open func percentUpdateDuringScrolling(_ percent:CGFloat){
        if percent > 1.0{
            guard self.imageView.transform == CGAffineTransform.identity else{
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi+0.000001)
            })
            textLabel.text = textDic[.releaseToAction]
        }
        if percent <= 1.0{
            guard self.imageView.transform == CGAffineTransform(rotationAngle: -CGFloat.pi+0.000001) else{
                return
            }
            textLabel.text = textDic[.scrollToAction]
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        }
    }
    open func didBeginRefreshing() {

    }
    open func didCompleteEndRefershingAnimation() {
        textLabel.text = textDic[.scrollToAction]
    }
    
    // MARK: Tintable
    func setThemeColor(themeColor: UIColor) {
        imageView.tintColor = themeColor
        textLabel.textColor = themeColor
    }
}

class RefreshLeftContainer:UIView{
    // MARK: - Propertys -
    enum RefreshHeaderState {
        case idle
        case pulling
        case refreshing
        case willRefresh
    }
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    weak var delegate:RefreshableLeftRight?
    fileprivate var _state:RefreshHeaderState = .idle
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
            case .refreshing:
                DispatchQueue.main.async(execute: {
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
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = .flexibleWidth
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life circle -
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
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
    fileprivate func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.old,.new], context: nil)
    }
    fileprivate func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }
    func handleScrollOffSetChange(_ change: [NSKeyValueChangeKey : Any]?){
        if state == .refreshing {
            return;
        }
        let offSetX = attachedScrollView.contentOffset.x
        let topShowOffsetX = -1.0 * attachedScrollView.contentInset.left
        guard offSetX <= topShowOffsetX else{
            return
        }
        let normal2pullingOffsetX = topShowOffsetX - self.frame.size.width
        let percent = (topShowOffsetX - offSetX)/self.frame.size.width
        if attachedScrollView.isDragging {
            self.delegate?.percentUpdateDuringScrolling(percent)
            if state == .idle && offSetX < normal2pullingOffsetX {
                self.state = .pulling
            }else if state == .pulling && offSetX >= normal2pullingOffsetX{
                state = .idle
            }
        }else if state == .pulling{
            beginRefreshing()
        }
    }
    // MARK: - KVO -
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
                ()
            }
        }
    }
    func endRefreshing(){
        self.state = .idle
    }

    
}
