source 'https://github.com/CocoaPods/Specs.git'
workspace 'Arcanos.xcworkspace'
use_frameworks!

def shared_pods
  pod 'RxSwift', '4.5.0', :inhibit_warnings => true
  pod 'RxCocoa', '4.5.0', :inhibit_warnings => true
  pod 'SwiftRex/UsingRxSwift', '0.4.0'
  pod 'SwiftRex-LoggerMiddleware/UsingRxSwift'
end

def shared_pods_with_reachability
  shared_pods
  pod 'SwiftRex-ReachabilityMiddleware/UsingRxSwift'
end

target 'Core iOS' do
  platform :ios, '10.0'
  project 'Core/Core.xcodeproj'
  shared_pods_with_reachability
end

target 'Core watchOS' do
  platform :watchos, '4.0'
  project 'Core/Core.xcodeproj'
  shared_pods
end

target 'Core tvOS' do
  platform :tvos, '10.0'
  project 'Core/Core.xcodeproj'
  shared_pods_with_reachability
end

target 'Core macOS' do
  platform :macos, '10.12'
  project 'Core/Core.xcodeproj'
  shared_pods_with_reachability
end

target 'ArcanosRadio iOS' do
  platform :ios, '10.0'
  project 'ArcanosRadio/ArcanosRadio.xcodeproj'
  shared_pods_with_reachability
  # pod 'RxDataSources'
end

target 'ArcanosRadio watchOS Extension' do
  platform :watchos, '4.0'
  project 'ArcanosRadio/ArcanosRadio.xcodeproj'
  shared_pods
end

target 'ArcanosRadio tvOS' do
  platform :tvos, '10.0'
  project 'ArcanosRadio/ArcanosRadio.xcodeproj'
  shared_pods_with_reachability
  # pod 'RxDataSources'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
            config.build_settings['SWIFT_VERSION'] = "4.2"
            config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = "YES"

            if target.name == 'RxSwift' && config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
        end
    end
end
