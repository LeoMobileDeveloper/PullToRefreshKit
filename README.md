
<p align="center">

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/logo.png" alt="PullToRefreshKit" title="PullToRefreshKit"/>

</p>

[![Apps Using](https://img.shields.io/cocoapods/at/PullToRefreshKit.svg?label=Apps%20Using%20PullToRefreshKit&colorB=28B9FE)](http://cocoapods.org/pods/PullToRefreshKit)
[![Downloads](https://img.shields.io/cocoapods/dt/PullToRefreshKit.svg?label=Total%20Downloads&colorB=28B9FE)](http://cocoapods.org/pods/PullToRefreshKit)
 [![Version](https://img.shields.io/cocoapods/v/PullToRefreshKit.svg?style=flat)](http://cocoapods.org/pods/PullToRefreshKit)  [![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
 [![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
 [![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)


**The example project contains some hot App refresh example.**

<table>
<tr>
<th>Taobao</th>
<th>YouKu</th>
<th>QQ Video</th>


</tr>
<tr>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/taobao.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/youku.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/qqvideo.gif" width="300"/></td>

</tr>
<tr>
<tr>
<th>Yahoo Weather</th>
<th>Dian Ping</th>
<th>QQ</th>
</tr>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/yahoo.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/dianping.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/qq.gif" width="300"/></td>
</tr>
<tr>
</table>


## Require

- iOS 8
- Swift 4+
- XCode 9+

For Swift 3, See branch [Swift3](https://github.com/LeoMobileDeveloper/PullToRefreshKit/tree/Swift3)

## Support

UITableView/UICollectionView/UIScrollView/UIWebView

- [x] Pull to refresh.
- [x] Pull/Tap to load more.
- [x] Pull left/right to load more(Currently only support chinese)
- [x] Elastic refresh 
- [x] Easy to customize
- [x] English and Chinese


## Install

CocoaPod

```
pod "PullToRefreshKit"
```

Carthage

```
github "LeoMobileDeveloper/PullToRefreshKit"
```

## Useage

> What is a container?
> A container is the object that hold the scrollView reference, most time it is a UIViewController object

### Pull down to refresh


```
self.tableView.configRefreshHeader(container:self) { [weak self] in
    delay(2, closure: {
        self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
    })
}
```

If you do not want any delay:

```
self.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif1.gif" width="320">


### Pull up to load more

Support three mode to fire refresh action  

- [x] Tap
- [x] Scroll
- [x] Scroll and Tap

```
self.tableView.configRefreshFooter(container:self) { [weak self] in
	delay(1.5, closure: {
	    self?.tableView.switchRefreshFooter(to: .normal)
	})
};
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif2.gif" width="320">

Remove footer:

```
self.tableView.switchRefreshFooter(to: .removed)
```

No more Data

```
self.tableView.switchRefreshFooter(to: .noMoreData)
```

### Pull left to exit

```
scrollView.configSideRefresh(with: DefaultRefreshLeft.left(), container:self, at: .left) {
   self.navigationController?.popViewController(animated: true)
};
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif3.gif" width="200">

### Pull right to Pop

```
let right  = DefaultRefreshRight.right()
right.setText("👈滑动关闭", mode: .scrollToAction)
right.setText("松开关闭", mode: .releaseToAction)
right.textLabel.textColor = UIColor.orange
scrollView.configSideRefresh(with: right, container:self, at: .right) { [weak self] in
    self?.navigationController?.popViewController(animated: true)
};
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif4.gif" width="200">

### Config the default refresh text

PullToRefershKit offer `SetUp` operator，for example

```
let header = DefaultRefreshHeader.header()
header.setText("Pull to refresh", mode: .pullToRefresh)
header.setText("Release to refresh", mode: .releaseToRefresh)
header.setText("Success", mode: .refreshSuccess)
header.setText("Refreshing...", mode: .refreshing)
header.setText("Failed", mode: .refreshFailure)
header.tintColor = UIColor.orange
header.imageRenderingWithTintColor = true
header.durationWhenHide = 0.4
self.tableView.configRefreshHeader(with: header,container:self) { [weak self] in
    delay(1.5, closure: {
        self?.models = (self?.models.map({_ in random100()}))!
        self?.tableView.reloadData()
        self?.tableView.switchRefreshHeader(to: .normal(.success, 0.3))
    })
};
```

### Customize

You just need to write a `UIView` sub class,and make it conforms to these protocols

- `RefreshableHeader`
- `RefreshableFooter`
- `RefreshableLeftRight` 

For exmaple,to create a custom header

``` 
    //Height of the refresh header
    func heightForHeader()->CGFloat
    
    //Distance from top when in refreshing state
    func heightForRefreshingState()->CGFloat
   
    //Will enter refreshing state,change view state to refreshing in this function
    func didBeginrefreshingState()

    //The refreshing task is end.Refresh header will hide.Tell user the refreshing result here.
    func didBeginHideAnimation(result:RefreshResult)
    
    //Refresh header is hidden,reset all to inital state here
    func didCompleteHideAnimation(result:RefreshResult)
    
    //Distance to drag to fire refresh action ,default is heightForRefreshingState
    optional func heightForFireRefreshing()->CGFloat
    
    //Percent change during scrolling
    optional func percentUpdateDuringScrolling(percent:CGFloat)
    
    //Duration of header hide animation
    optional func durationOfHideAnimation()->Double
    
```


## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.
