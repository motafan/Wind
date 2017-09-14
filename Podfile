# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
source "https://github.com/CocoaPods/Specs.git”
inhibit_all_warnings!

def pods
    pod 'RxSwift',          '~> 3.6.1'
    pod 'RxCocoa',          '~> 3.6.1'
    pod 'RxBlocking',       '~> 3.6.1'
    pod 'RxDataSources',    '~> 2.0.2'
    pod 'RxSwiftUtilities', '~> 1.0.1'
    pod 'NSObject+Rx',      '~> 3.0.0'
    pod 'RxAlamofire',      '~> 3.0.3'
    pod 'Charts',           '~> 3.0.3'
    pod 'ReSwift',          '~> 4.0.0'
    pod 'RxOptional',       '~> 3.1.3'
    pod 'SwiftTheme',       '~> 0.3.3'
    pod 'SwifterSwift',     '~> 1.6.4'
    pod 'Kingfisher',       '~> 3.13.0'
    pod 'SwiftyJSON',       '~> 3.1.4'
    pod 'HandyJSON',        '~> 1.8.0'
    pod 'Alamofire',        '~> 4.5.1'
    pod 'Moya',             '~> 9.0.0', :subspecs => ['Core', 'RxSwift']
    pod 'SnapKit',          '~> 3.2.0'
    pod 'DeviceGuru',       '~> 2.1.0'
    pod 'AudioBot',         '~> 1.1.1'
    pod 'AutoReview',       '~> 1.0.0'
    pod 'Ruler',            '~> 1.0.1'
    pod 'RealmSwift',       '~> 2.8.3'
    pod 'IBAnimatable',     '~> 4.1.0'
    pod 'R.swift',          '~> 3.2.0'
    pod 'Router',           :git=> "https://github.com/ilumanxi/Router.git" #,           '~> 1.0.0',
    pod 'SwiftDate',        '~> 4.1.11'
    pod 'mp3lame-for-ios',  '~> 0.1.1'
    pod 'GPUImage',         '~> 0.1.7'
    pod 'MWPhotoBrowser',   '~> 2.1.2'
    pod 'TZImagePickerController', '~> 1.9.3'
#    pod 'LFMediaEditingController', '~> 1.1.1'
    pod 'LFCameraPickerController', '~> 1.0.3'
    pod 'ImagePickerSheetViewController', '~> 1.0.8'
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
