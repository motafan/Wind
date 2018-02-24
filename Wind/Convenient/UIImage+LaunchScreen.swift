//
//  UIImage+LaunchScreen.swift
//  Wind
//
//  Created by 谭帆帆 on 2018/2/24.
//  Copyright © 2018年 tanfanfan. All rights reserved.
//

import UIKit

extension UIDeviceOrientation {
    
    var launchImageDescription: String {
        switch self {
        case .landscapeLeft,.landscapeRight:
            return "Landscape"
        case .portrait,.portraitUpsideDown:
            fallthrough
        default:
            return "Portrait"
        }
    }
}


extension UIScreen {
    
    var size: CGSize {
        return self.bounds.size
    }
}

extension UIImage {
    
    private struct UILaunchImageAssociatedKeys {
        static let images = "UILaunchImages"
        static let minimumOSVersion = "UILaunchImageMinimumOSVersion"
        static let imageName = "UILaunchImageName"
        static let orientation = "UILaunchImageOrientation"
        static let imageSize = "UILaunchImageSize"
    }
    
    static func launchImage(orientation: UIDeviceOrientation? = nil) -> UIImage? {
        
        let UILaunchImageSize = UIScreen.main.size
        let UILaunchImageOrientation = orientation?.launchImageDescription ?? UIDevice.current.orientation.launchImageDescription
        guard let UILaunchImages = Bundle.main.infoDictionary?[UILaunchImageAssociatedKeys.images]
            as? Array<Dictionary<String, String>>  else {
                return nil
        }
        
        let launchImageName = UILaunchImages
            .filter { launchImage -> Bool in
                guard let launchImageSize = launchImage[UILaunchImageAssociatedKeys.imageSize],
                    let launchImageOrientation = launchImage[UILaunchImageAssociatedKeys.orientation] else {
                        return false
                }
                
                return
                    UILaunchImageOrientation == launchImageOrientation &&
                    UILaunchImageSize == CGSizeFromString(launchImageSize)
            }
            .first?[UILaunchImageAssociatedKeys.imageName]
        
        guard let _ = launchImageName else {
            return nil
        }
        
        return UIImage(named: launchImageName!)
        
    }
}
