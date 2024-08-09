Pod::Spec.new do |s|
  s.name             = "PSANotificationService"
  s.version          = "0.0.1"
  s.summary          = "A simple Notification Service Extension class to add media attachments to iOS 10 rich push notifications."
  s.homepage         = "http://EXAMPLE/PSANotificationService"
  s.license          = "MIT"
  s.author           = "PSA"
  s.source           = { :http => 'file:' + __dir__ + '/PSANotificationService' }
  s.requires_arc     = true
  s.platform         = :ios, '11.0'
  s.weak_frameworks  = 'UserNotifications'
  s.source_files     = 'PSANotificationService/*.{m,h,swift}' 
end
