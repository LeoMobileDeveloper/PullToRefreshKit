//
//  ElasticRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/29.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

public class ElasticRefreshHeader: UIView,RefreshableHeader {
    
    let control:ElasticRefreshControl
    override init(frame: CGRect) {
        control = ElasticRefreshControl(frame: frame)
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func distanceToRefresh() -> CGFloat {
        return 60.0
    }
    public func percentUpdateWhenNotRefreshing(percent:CGFloat){
        self.hidden = !(percent > 0.0)
        
    }
    public func didBeginEndRefershingAnimation(result:RefreshResult) {
     
    }
    public func didCompleteEndRefershingAnimation(result:RefreshResult) {
       
    }
    public func didBeginrefreshingState() {
        self.control
    }

}