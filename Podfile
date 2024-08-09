# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'dummy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for dummy
#  pod 'SnowplowTracker', '~> 5.0'
#  pod 'SnowplowTracker', :path => 'SubModule/snowplow-ios-tracker-master/SnowplowTracker.podspec'
pod 'PSATracker', :path => 'SubModule/PSATracker/PSATracker.podspec'
  
end

target 'PsaNotificationCenter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
 
  # Pods for PsaNotificationCenter
#  pod 'SnowplowTracker', '~> 5.0'
  pod 'PSANotificationService', :path => 'SubModule/PSANotificationService/PSANotificationService.podspec'
  pod 'PSATracker', :path => 'SubModule/PSATracker/PSATracker.podspec'
#  pod 'SnowplowTracker', :path => 'SubModule/snowplow-ios-tracker-master/SnowplowTracker.podspec'
 
end

target 'PsaNotificationContentCenter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
 
  # Pods for PsaNotificationCenter
#  pod 'SnowplowTracker', '~> 5.0'
  pod 'PSANotificationContent', :path => 'SubModule/PSANotificationContent/PSANotificationContent.podspec'
  pod 'PSATracker', :path => 'SubModule/PSATracker/PSATracker.podspec'
#  pod 'SnowplowTracker', :path => 'SubModule/snowplow-ios-tracker-master/SnowplowTracker.podspec'
  
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

