
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
[![Build Status](https://travis-ci.org/LeoMobileDeveloper/PullToRefreshKit.svg?branch=master)](https://travis-ci.org/LeoMobileDeveloper/PullToRefreshKit)

**The example project contains some hot App refresh example.**

<table>
<tr>
<th>Taobao</th>
<th>YouKu</th>
<th>QQ Video</th>
<th>QQ</th>

</tr>
<tr>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/taobao.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/youku.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/qqvideo.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/qq.gif" width="300"/></td>

</tr>
<tr>
<tr>
<th>Curve</th>
<th>Yahoo Weather</th>
<th>Dian Ping</th>
</tr>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/curve.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/yahoo.gif" width="300"/></td>
<td><img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/dianping.gif" width="300"/></td>
</tr>
<tr>
</table>


## Require

- iOS 8
- Swift 4.0

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

### Pull down to refresh


```
 self.tableView.setUpHeaderRefresh { [weak self] in
    delay(1.5, closure: { 
         self?.tableView.endHeaderRefreshing(.Success)
    })
 }
```
Add a delay if you want user to see the result of refresh result

```
self?.tableView.endHeaderRefreshing(.Success,delay: 0.5)

```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif1.gif" width="320">


### Pull up to load more

Support three mode to fire refresh action
- [x] Tap
- [x] Scroll
- [x] Scroll and Tap

```
 self.tableView.setUpFooterRefresh {  [weak self] in
     delay(1.5, closure: {
         self?.tableView.endFooterRefreshing()
     })
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif2.gif" width="320">


### Pull left to exit

```
 scrollView.setUpLeftRefresh { [weak self] in
     self?.navigationController?.popViewControllerAnimated(true)
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif3.gif" width="200">

### Pull right to enter

```
 scrollView.setUpRightRefresh { [weak self] in
     let nvc = DefaultBannerController()
     self?.navigationController?.pushViewController(nvc, animated: true)
 }
```

<img src="https://raw.github.com/LeoMobileDeveloper/PullToRefreshKit/master/Screenshot/gif4.gif" width="200">

### Config the default refresh text

PullToRefershKit offer `SetUp` operator，for example

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

### Customize

You just need to write a `UIView` sub class,and make it conforms to these protocols

- RefreshableHeader 
- RefreshableFooter 
- RefreshableLeftRight 

For exmaple,to create a custom header
```
    //Distance from top when in refreshing state
    func heightForRefreshingState()->CGFloat
   
    //Will enter refreshing state,change view state to refreshing in this function
    func didBeginrefreshingState()

    //The refreshing task is end.Refresh header will hide.Tell user the refreshing result here.
    func didBeginEndRefershingAnimation(result:RefreshResult)
    
    //Refresh header is hidden,reset all to inital state  here
    func didCompleteEndRefershingAnimation(result:RefreshResult)
    
    //Distance to drag to fire refresh action ,default is heightForRefreshingState
    optional func heightForFireRefreshing()->CGFloat
    
    //Percent change during scrolling
    optional func percentUpdateDuringScrolling(percent:CGFloat)
    
    //Duration of header hide animation
    optional func durationWhenEndRefreshing()->Double
    
```


## Author

Leo, leomobiledeveloper@gmail.com

## License

PullToRefreshKit is available under the MIT license. See the LICENSE file for more info.
