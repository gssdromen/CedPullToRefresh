#
#  Be sure to run `pod spec lint CedPullToRefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CedPullToRefresh"
  s.version      = "0.0.2"
  s.summary      = "CedPullToRefresh"

  s.description  = <<-DESC
  CedPullToRefresh123123
                   DESC

  s.homepage     = "http://www.ba.com/CedPullToRefresh"
  s.license      = "MIT"
  s.author             = { "wuyinjun" => "wuyinjun@fangdd.com" }
  s.source       = { :git => "http://www.ba.com/CedPullToRefresh.git", :tag => "#{s.version}" }

  s.source_files  = "CedPullToRefresh/**/*.{swift}"
  s.ios.deployment_target = '8.0'
end
