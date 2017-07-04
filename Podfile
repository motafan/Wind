# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
source "https://github.com/CocoaPods/Specs.git”
inhibit_all_warnings!

def pods
    pod 'RxSwift'#,          '~> 3.5.0'
    pod 'RxCocoa'#,          '~> 3.5.0'
    pod 'RxBlocking'#,       '~> 3.5.0'
    pod 'RxDataSources',    '~> 1.0.4'
    pod 'RxSwiftUtilities', '~> 1.0.1'
    pod 'RxMediaPicker',    '~> 1.1.0'
    pod 'RxAlamofire',      '~> 3.0.3'
    pod 'Charts',           '~> 3.0.2'
    #pod 'ReSwift',          '~> 4.0.0'
    #pod 'ReSwiftRouter',    '~> 0.5.1'
    #pod 'ReSwiftRecorder',  '~> 0.4.0'
    #pod 'RxOptional',       '~> 3.1.3'
    pod 'NSObject+Rx',      '~> 2.3.0'
    pod 'SwiftTheme',       '~> 0.3.3'
    pod 'SwifterSwift',     '~> 1.6.4'
    pod 'Kingfisher',       '~> 3.10.2'
    pod 'SwiftyJSON',       '~> 3.1.4'
    pod 'HandyJSON',        '~> 1.7.2'
    pod 'Alamofire',        '~> 4.5.0'
    pod 'Moya',             '~> 8.0.5', :subspecs => ['Core', 'RxSwift']
    pod 'SnapKit',          '~> 3.2.0'
    pod 'DeviceGuru',       '~> 2.1.0'
    pod 'AudioBot',         '~> 1.1.1'
    pod 'AutoReview',       '~> 1.0.0'
    pod 'Ruler',            '~> 1.0.1'
    pod 'RealmSwift',       '~> 2.8.3'
    pod 'IBAnimatable',     '~> 4.1.0'
    pod 'R.swift',          '~> 3.2.0'
    pod 'Router',           :git=> "https://github.com/ilumanxi/Router.git" #,           '~> 1.0.0',
    pod 'SwiftDate',        '~> 4.1.2'
    pod 'mp3lame-for-ios',  '~> 0.1.1'
end

target 'Wind' do
    
  # Pods for Wind
  pods
  
  target 'WindTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WindUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
