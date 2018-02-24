# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
source "https://github.com/CocoaPods/Specs.git”
inhibit_all_warnings!

def pods
    pod 'RxSwift',          '~> 4.1.2'
    pod 'RxCocoa',          '~> 4.1.2'
    pod 'RxBlocking',       '~> 4.1.2'
    pod 'RxDataSources',    '~> 3.0.2'
    pod 'NSObject+Rx',      '~> 4.2.0'
    pod 'RxAlamofire',      '~> 4.0.0'
    pod 'Charts',           '~> 3.0.5'
    pod 'ReSwift',          '~> 4.0.1'
    pod 'RxOptional',       '~> 3.3.0'
    pod 'SwiftTheme',       '~> 0.4.1'
    pod 'SwifterSwift',     '~> 4.1.1'
    pod 'Kingfisher',       '~> 4.6.2'
    pod 'SwiftyJSON',       '~> 4.0.0'
    pod 'HandyJSON',        '~> 4.0.0-beta.1'
    pod 'Alamofire',        '~> 4.6.0'
    pod 'Moya',             '~> 11.0.0', :subspecs => ['Core', 'RxSwift']
    pod 'SnapKit',          '~> 4.0.0'
    pod 'DeviceGuru',       '~> 3.0.1'
    pod 'AudioBot',         '~> 1.1.1'
    pod 'AutoReview',       '~> 1.0.0'
    pod 'Ruler',            '~> 2.1.0'
    pod 'RealmSwift',       '~> 3.1.1'
    pod 'IBAnimatable',     '~> 5.0.0'
    pod 'R.swift',          '~> 4.0.0'
    pod 'Router',           :git=> "https://github.com/ilumanxi/Router.git" #,           '~> 1.0.0',
    pod 'SwiftDate',        '~> 4.5.1'
    pod 'mp3lame-for-ios',  '~> 0.1.1'
    pod 'GPUImage',         '~> 0.1.7'
    pod 'MWPhotoBrowser',   '~> 2.1.2'
    pod 'TZImagePickerController', '~> 2.0.0.6'
    pod 'LFCameraPickerController', '~> 1.0.7'
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

#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['SWIFT_VERSION'] = '3.2'
#        end
#    end
#end

