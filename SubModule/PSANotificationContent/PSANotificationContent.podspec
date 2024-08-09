Pod::Spec.new do |s|
  s.name             = "PSANotificationContent"
  s.version          = "0.0.1"
  s.summary          = "A Notification Content Extension class to display custom content interfaces for iOS 10 push notifications"
  s.homepage         = "http://EXAMPLE/PSANotificationContent"
  s.license          = "MIT"
  s.author           = "PSA"
  s.source           = { :http => 'file:' + __dir__ + '/PSANotificationContent' }
  s.requires_arc     = true
  s.platform         = :ios, '10.0'
  s.weak_frameworks  = 'UserNotifications', 'UIKit'
  s.source_files     = 'PSANotificationContent/**/*.{h,m,swift}'
  s.resources        = 'PSANotificationContent/**/*.{png,xib}'
  s.swift_version    = '5.0'
end
