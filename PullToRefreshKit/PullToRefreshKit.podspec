#
# Be sure to run `pod lib lint PullToRefreshKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PullToRefreshKit'
  s.version          = '0.1.0'
  s.summary          = 'A lib to help you create pull down to refresh,pull up to load more,pull left/right to do some action.'

  s.description      = <<-DESC
PullToRefreshKit is an colleciton of "Pull to refresh" method. With this lib,you can create pull down to refresh,pull up to laod more,pull left/right to do some action.Besides,it is quite easy to make a custom refresh view.
                       DESC

  s.homepage         = 'https://github.com/LeoMobileDeveloper/PullToRefreshKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Leo' => 'leomobiledeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/LeoMobileDeveloper/PullToRefreshKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/Classes/**/*'
  
  s.resource_bundles = {
     'PullToRefreshKit' => ['Source/Assets/*.png']
  }

end
