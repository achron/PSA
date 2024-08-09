#
#  Be sure to run `pod spec lint PSATracker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

spec.name         = "PSATracker"
spec.version      = "0.0.1"
spec.summary      = "PSATracker is a mobile and event analytics platform."


spec.description  = <<-DESC
PSATracker is a mobile and event analytics platform.
DESC

spec.homepage     = "http://EXAMPLE/PSATracker"
# spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

spec.license      = "MIT"
# spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

spec.author             = "PSA"
spec.social_media_url   = "https://twitter.com/PSA"

spec.swift_version = '5.0'
spec.ios.deployment_target = '11.0'
spec.osx.deployment_target = '10.13'
spec.tvos.deployment_target = '12.0'
spec.watchos.deployment_target = '6.0'

#  spec.source = { :git => "http://EXAMPLE/PSATracker.git", :tag => "#{spec.version}" }

spec.source = { :http => 'file:' + __dir__ + '/PSATracker' }


spec.source_files = 'PSATracker/Tracker/Sources/**/*.swift'
# spec.exclude_files = "Classes/Exclude"

# spec.public_header_files = "Classes/**/*.h"




# spec.resource  = "icon.png"
# spec.resources = "Resources/*.png"

# spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

spec.ios.frameworks = 'CoreTelephony', 'UIKit', 'Foundation'
spec.osx.frameworks = 'AppKit', 'Foundation'
spec.tvos.frameworks = 'UIKit', 'Foundation'


spec.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }

spec.dependency 'FMDB', '~> 2.7'

end
