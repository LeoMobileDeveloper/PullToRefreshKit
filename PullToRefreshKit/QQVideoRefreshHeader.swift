//
//  QQVideoRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/8/1.
//  Copyright © 2016年 Leo. All rights reserved.
//
import Foundation
import UIKit

class QQVideoRefreshHeader:UIView,RefreshableHeader{
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: 0, y: 0, width: 27, height: 10)
        imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        imageView.image = UIImage(named: "loading15")
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RefreshableHeader -
    func heightForRefreshingState()->CGFloat{
        return 50
    }
    func stateDidChanged(_ oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .pulling{
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        }
        if newState == .idle{
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        imageView.image = nil
        let images = (0...29).map{return $0 < 10 ? "loading0\($0)" : "loading\($0)"}
        imageView.animationImages = images.map{return UIImage(named:$0)!}
        imageView.animationDuration = Double(images.count) * 0.04
        imageView.startAnimating()
    }
    //刷新结束，将要隐藏header
    func didBeginEndRefershingAnimation(_ result:RefreshResult){}
    //刷新结束，完全隐藏header
    func didCompleteEndRefershingAnimation(_ result:RefreshResult){
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.image = UIImage(named: "loading15")
    }
}
