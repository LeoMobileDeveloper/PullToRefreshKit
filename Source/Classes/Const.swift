//
//  RefreshUtil.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit


struct PullToRefreshKitConst{
    //KVO
    static let KPathOffSet = "contentOffset"
    static let KPathPanState = "state"
    static let KPathContentSize = "contentSize"
    
    //Default const
    static let defaultHeaderHeight:CGFloat = 50.0
    static let defaultFooterHeight:CGFloat = 44.0
    static let defaultLeftWidth:CGFloat    = 50.0
    static let defaultRightWidth:CGFloat   = 50.0
    
    //Tags
    static let headerTag = 100001
    static let footerTag = 100002
    static let leftTag   = 100003
    static let rightTag  = 100004
}

struct PullToRefreshKitHeaderString{
    static let pullDownToRefresh = "下拉可以刷新"
    static let releaseToRefresh = "松开立即刷新"
    static let refreshSuccess = "刷新成功"
    static let refreshError = "刷新出错"
    static let refreshFailure = "刷新失败"
    static let refreshing = "正在刷新数据中..."
}

struct PullToRefreshKitFooterString{
    static let pullUpToRefresh = "上拉加载更多数据"
    static let refreshing = "正在加载中..."
    static let noMoreData = "数据加载完毕"
    static let tapToRefresh = "点击加载更多"
    static let scrollAndTapToRefresh = "上拉或点击加载更多"
}

struct PullToRefreshKitLeftString{
    static let scrollToClose = "滑动结束浏览"
    static let releaseToClose = "松开结束浏览"
}

struct PullToRefreshKitRightString{
    static let scrollToViewMore = "滑动浏览更多"
    static let releaseToViewMore = "滑动浏览更多"
}

