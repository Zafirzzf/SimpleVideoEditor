# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://git.ourbluecity.com/finka/ios/AHPodsSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
inhibit_all_warnings!

target 'SimpleVideoEditor' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleVideoEditor
    pod 'RxSwift', '6.6.0'
    pod 'RxCocoa', '6.6.0'
    pod 'NimbleKit'
    pod 'SnapKit' , '5.7.1'
    pod 'SwiftDate', '7.0.0'
    pod 'Bugly',  '2.5.93'
    pod 'SwiftyNotification'
    pod 'Ads-CN-Beta', '6.0.0.1'
    pod 'AHProgressView',                   '1.7.0'
    pod 'ObjectMapper'
    pod 'SwiftyPreference'

    pod 'DeviceDefine',                     '0.3.0'
    pod 'AHLogRecorder', :git => 'https://git.ourbluecity.com/finka/ios/AHLogRecorder', :tag => '0.1.6'
    pod 'AHUIKitExtension', :git => 'https://git.ourbluecity.com/finka/ios/AHUIKitExtension', :tag => '2.9.0'


end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_ABOUT_RETURN_TYPE'] = 'YES'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings['SWIFT_VERSION'] = '5.0'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
