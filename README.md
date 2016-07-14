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

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/
Screenshot/gif2.gif" width="320">


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

###自定义下刷新界面
对于自定义界面，你唯一要做的就是写一个UIView的子类，然后实现以下协议中的一个

- RefreshableHeader 自定义下拉刷新要实现的协议
- RefreshableFooter 自定义上拉加载要实现的协议
- RefreshableLeftRight 自定义左右滑动要实现的协议

例如，Demo工程[TaoBaoRefreshHeader.swift](https://github.com/LeoMobileDeveloper/PullToRefreshKit/blob/master/PullToRefreshKit/TaoBaoRefreshHeader.swift)中实现了淘宝App的下拉刷新例子。

你只需要根据协议提供的回调来更新时图的状态

## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.
