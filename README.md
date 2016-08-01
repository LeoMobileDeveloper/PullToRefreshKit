
<p align="center">

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/logo.png" alt="PullToRefreshKit" title="PullToRefreshKit"/>

</p>


 [![Version](https://img.shields.io/cocoapods/v/PullToRefreshKit.svg?style=flat)](http://cocoapods.org/pods/PullToRefreshKit)  [![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
 [![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
 [![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

一行代码实现下拉刷新

```
self.tableView.setUpHeaderRefresh { [weak self] in
   delay(1.5, closure: { 
        self?.tableView.endHeaderRefreshing(.Success)
   })
}
```
内置橡皮筋刷新,两行搞定

```
let elasticHeader = ElasticRefreshHeader()
self.tableView.setUpHeaderRefresh(elasticHeader) { [weak self] in
    delay(1.5, closure: { 
        self?.tableView.endHeaderRefreshing(.Success)
   })
}
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif5.gif" width="320">


支持:

- [x] 默认下拉刷新一行代码，支持提醒用户刷新结果（成功，失败）
- [x] 默认上拉加载一行代码，支持三种模式，点击/上拉／点击和上拉
- [x] 默认左拉/又拉进行回调一行搞定
- [x] 内置橡皮筋下拉刷新
- [x] 几十行代码即可自定义刷新界面



Demo中，我列举了用这个框架如何实现[淘宝](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/TaoBaoRefreshHeader.swift)和[大众点评](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/DianpingRefreshHeader.swift)的[优酷](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/YoukuRefreshHeader.swift)下拉刷新。

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/taobao.gif" width="200"><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/dianping.gif" width="200">
<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/youku.gif" width="200">

## 要求

- iOS 8
- Swift 2

支持

- UITableView
- UICollectionView
- UIScrollView
- UIWebView


## 安装
推荐使用CocoaPod安装

```
pod "PullToRefreshKit"
```
## 使用

对于默认效果的，你只需要一行代码即可

###下拉刷新

```
 self.tableView.setUpHeaderRefresh { [weak self] in
    delay(1.5, closure: { 
         self?.tableView.endHeaderRefreshing(.Success)
    })
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif1.gif" width="320">


###上拉加载
目前上拉加载支持三种模式：Tap，Scroll,TapAndScroll.通过设置footer的refreshMode来设置

```
 self.tableView.setUpFooterRefresh {  [weak self] in
     delay(1.5, closure: {
         self?.tableView.endFooterRefreshing()
     })
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif2.gif" width="320">


###左拉退出当前界面

```
 scrollView.setUpLeftRefresh { [weak self] in
     self?.navigationController?.popViewControllerAnimated(true)
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif3.gif" width="200">

###右拉进入下一个界面

```
 scrollView.setUpRightRefresh { [weak self] in
     let nvc = DefaultBannerController()
     self?.navigationController?.pushViewController(nvc, animated: true)
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif4.gif" width="200">

###配置默认的属性
PullToRefershKit提供操作符`SetUp`来实现配置，例如,配置默认header

```
self.tableView.setUpHeaderRefresh { [weak self] in
    delay(1.5, closure: {
        self?.tableView.endHeaderRefreshing(.Success)
    })
}.SetUp { (header) in
    header.setText("Pull to refresh", mode: .pullToRefresh)
    header.setText("Release to refresh", mode: .releaseToRefresh)
    header.setText("Success", mode: .refreshSuccess)
    header.setText("Refreshing...", mode: .refreshing)
    header.setText("Failed", mode: .refreshFailure)
    header.setText("Error", mode: .refreshError)
    header.textLabel.textColor = UIColor.orangeColor()
    header.imageView.image = nil
}
```

###自定义刷新界面

对于自定义界面，你唯一要做的就是写一个UIView的子类，然后实现以下协议中的一个

- RefreshableHeader 自定义下拉刷新要实现的协议
- RefreshableFooter 自定义上拉加载要实现的协议
- RefreshableLeftRight 自定义左右滑动要实现的协议

例如，Demo工程[TaoBaoRefreshHeader.swift](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/TaoBaoRefreshHeader.swift)中实现了淘宝App的下拉刷新例子。

你只需要根据协议提供的回调来更新Header的状态

这个协议提供的方法如下

```
    //在刷新状态的时候，距离顶部的距离
    func heightForRefreshingState()->CGFloat
   
    //马上就要进入刷新的回调,在这里将header调整为刷新中的样式
    func didBeginrefreshingState()

    //结束刷新，在这里可以告诉用户刷新的结果
    func didBeginEndRefershingAnimation(result:RefreshResult)
    
    //结束刷新，在这里把视图恢复到最初状态
    func didCompleteEndRefershingAnimation(result:RefreshResult)
    
    //拖拽触发刷新的高度，如果不提供，就是heightForRefreshingState
    optional func heightForFireRefreshing()->CGFloat
    
    //刷新的时候，百分比变化，可以根据这个百分比动态的绘制你的视图
    optional func percentUpdateDuringScrolling(percent:CGFloat)
    
    //隐藏header的时间
    optional func durationWhenEndRefreshing()->Double
    
```


## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.

## Thanks
感谢[SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)和[MJRefresh](https://github.com/CoderMJLee/MJRefresh)，让我少走了很多弯路