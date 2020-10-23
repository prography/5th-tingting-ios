# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'


# ignore all warnings from all pods
inhibit_all_warnings!

target 'tingting' do
  use_frameworks!
  # ignore all warnings from all pods
  inhibit_all_warnings!
    
  pod 'Firebase/Analytics'
   
  #pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxSwiftExt', '~> 5'
  pod 'RxDataSources', '~> 4.0'
  pod 'RxViewController'

  pod 'DropDown', '~>2.3.13'
  pod 'Hero', '~> 1.4.0'
  pod 'SnapKit', '~> 5.0.0'
  pod 'lottie-ios', '~> 3.1.0'
  pod 'SwiftyBeaver', '~> 1.7.0'
  pod 'Kingfisher', '~> 5.0'

  pod 'NotificationBannerSwift', '~> 3.0.0'
  pod 'WSTagsField', '~> 5.2'
  pod 'M13Checkbox', '~> 3.4.0'
  pod 'TextFieldEffects', '~> 1.6.0'
  pod 'BonMot', '~> 5.4'
  
  pod 'RxKakaoSDK', '~> 2.0.0-beta.3'
  
  
  target 'tingtingTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'tingtingUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
# Workaround for @IBDesignable (https://github.com/CocoaPods/CocoaPods/issues/5334)
#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    next if target.product_type == "com.apple.product-type.bundle"
#    target.build_configurations.each do |config|
#      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
#    end
#  end
#end
