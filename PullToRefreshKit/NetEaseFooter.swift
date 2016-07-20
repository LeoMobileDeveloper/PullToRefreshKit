//
//  NetEaseFooter.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/19.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

class NetEaseFooter:UIView,RefreshableFooter{
    func distanceToRefresh() -> CGFloat {
        return 70.0
    }
    func didBeginRefreshing() {
        
    }
    func didUpdateToNoMoreData() {
        
    }
    func didEndRefreshing() {
        
    }
    func didResetToDefault() {
        
    }
    func shouldBeginRefreshingWhenScroll() -> Bool {
        return false
    }
}