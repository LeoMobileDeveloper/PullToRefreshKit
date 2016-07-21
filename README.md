
<p align="center">

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/logo.png" alt="PullToRefreshKit" title="PullToRefreshKit"/>

</p>


 [![Version](https://img.shields.io/cocoapods/v/PullToRefreshKit.svg?style=flat)](http://cocoapods.org/pods/PullToRefreshKit)  [![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
 [![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
 [![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

支持一行代码实现下拉刷新

```
self.tableView.setUpHeaderRefresh { [weak self] in
   delay(1.5, closure: { 
        self?.tableView.endHeaderRefreshing(.Success)
   })
}
```
这个库的设计初衷，是为了能够方便地实现自定义的下拉刷新，上拉加载等。比如，Demo中，我列举了用这个框架如何实现[淘宝](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/TaoBaoRefreshHeader.swift)和[大众点评](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/DianpingRefreshHeader.swift)的下拉刷新。


<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/taobao.gif" width="200"><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/dianping.gif" width="200">

## 要求

- iOS 8
- Swift 2

支持

- UITableView
- UICollectionView
- UIScrollView
- UIWebView(TODO)


## 安装
推荐使用CocoaPod安装
在PodFile最上面，添加

```
use_frameworks!

```

然后，添加一行


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
//触发刷新的距离，对于header/footer来讲，就是视图的高度；对于left/right来讲，就是视图的宽度
func distanceToRefresh()->CGFloat

//百分比回调，在这里你根据百分比来动态的调整你的刷新视图
func percentUpdateWhenNotRefreshing(percent:CGFloat)

//松手就会刷新的回调,在这个回调里，将视图切换到动画的状态
func releaseWithRefreshingState()

//刷新结束，将要进行隐藏的动画，一般在这里告诉用户刷新的结果
func didBeginEndRefershingAnimation(result:RefreshResult)

//刷新结束，隐藏的动画结束，一般在这里把视图隐藏，各个参数恢复到最初状态
func didCompleteEndRefershingAnimation(result:RefreshResult)
    
```


## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.

## Thanks
感谢[SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)和[MJRefresh](https://github.com/CoderMJLee/MJRefresh)，让我少走了很多弯路