# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :ios, '13.0'
inhibit_all_warnings!

target 'SimpleVideoEditor' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleVideoEditor
    pod 'RxSwift', '6.6.0'
    pod 'RxCocoa', '6.6.0'
    pod 'NimbleKit'
    pod 'SnapKit'
    pod 'SwiftDate'
    pod 'SwiftyNotification'
    pod 'Firebase/Analytics'
    
  target 'SimpleVideoEditorTests' do
    inherit! :search_paths
    # Pods for testing
  end

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
