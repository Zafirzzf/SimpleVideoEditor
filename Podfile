# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SimpleVideoEditor' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleVideoEditor
    pod 'RxSwift',                             '6.5.0'
    pod 'RxCocoa',                             '6.5.0'
    pod 'NimbleKit'
    pod 'SnapKit'
    pod 'SwiftDate'
    pod 'SwiftyNotification'
    pod 'RxKeyboard',                         '2.0.0'
    pod 'MJRefresh',                          '3.7.5'
    pod 'NSObject+Rx',                        '5.2.2'
    pod "RxGesture",                          '4.0.3'
#    pod 'DoraemonKit/Core',                   '3.1.2',  :configurations => ['Debug']
    
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
