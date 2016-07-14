# PullToRefreshKit
PullToRefreshKit 是用纯Swift写的，支持下拉刷新，上拉加载，左/右滑动进行额外的操作的库。

并且你只需要一行代码即可

```
self.tableView.setUpHeaderRefresh { [weak self] in
   delay(1.5, closure: { 
        self?.tableView.endHeaderRefreshing(.Success)
   })
}
```

## 要求

- iOS 8
- Swift 2



## 安装
推荐使用CocoaPod安装

```ruby
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

###自定义下刷新界面
对于自定义界面，你唯一要做的就是写一个UIView的子类，然后实现以下协议中的一个

- RefreshableHeader 自定义下拉刷新要实现的协议
- RefreshableFooter 自定义上拉加载要实现的协议
- RefreshableLeftRight 自定义左右滑动要实现的协议

例如，Demo工程[TaoBaoRefreshHeader.swift](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/TaoBaoRefreshHeader.swift)中实现了淘宝App的下拉刷新例子。

你只需要根据协议提供的回调来更新时图的状态

这个协议提供的方法如下

```
//触发刷新的距离，也是header的高度
func distanceToRefresh()->CGFloat
//已经开始刷新的回调
func didBeginRefreshing()
//拖拽过程中，拖拽百分比的回调
func percentageChangedDuringDragging(percent:CGFloat)
//将要开始刷新
func willBeginRefreshing()
//将要结束刷新，result是刷新的结果,对应着界面header将要隐藏
func willEndRefreshing(result:RefreshResult)
//已经结束刷新，result是刷新的结果,对应着界面header完全隐藏
func didEndRefreshing(result:RefreshResult)
```


## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.
