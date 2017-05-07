//
//  LaunchScreenViewController.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/5.
//  Copyright © 2017年 tanfanfan. All rights reserved.
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
    
    struct LaunchImageAssociatedKeys {
        static let UILaunchImages = "UILaunchImages"
        static let UILaunchImageMinimumOSVersion = "UILaunchImageMinimumOSVersion"
        static let UILaunchImageName = "UILaunchImageName"
        static let UILaunchImageOrientation = "UILaunchImageOrientation"
        static let UILaunchImageSize = "UILaunchImageSize"
    }
    
    static func launchImage() -> UIImage? {
        
        let UILaunchImageSize = UIScreen.main.size
        let UILaunchImageOrientation = UIDevice.current.orientation.launchImageDescription
        
        guard let UILaunchImages = Bundle.main.infoDictionary?[LaunchImageAssociatedKeys.UILaunchImages]
            as? Array<Dictionary<String,String>>  else {
            return nil
        }
        
        let UILaunchImageName = UILaunchImages.filter { UILaunchImage -> Bool in
            if UILaunchImageOrientation == UILaunchImage[LaunchImageAssociatedKeys.UILaunchImageOrientation] &&
                UILaunchImageSize == CGSizeFromString(UILaunchImage[LaunchImageAssociatedKeys.UILaunchImageSize] ?? ""){
                return true
            }
            return false
        }.first?[LaunchImageAssociatedKeys.UILaunchImageName] ?? ""
        
        return UIImage(named: UILaunchImageName)

    }
}


class LaunchScreenViewController: UIViewController {
    
    
    fileprivate static var window: UIWindow?
    
    private static let lock = 0
    
    class func showForRemainDuration(_ duration: TimeInterval) {
        doLocked {
            if case .none = window {
                window = UIWindow(frame: UIScreen.main.bounds)
                window!.windowLevel = UIWindowLevelStatusBar
                let stroyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
                let launchScreen: LaunchScreenViewController = stroyboard.instantiateViewController()
                window!.rootViewController = launchScreen
                window!.isHidden = false
                dismiss(duration)
            }
        }
    }
    
    class func dismiss(_ duration: TimeInterval) {
        doLocked {
            guard let launchScreen = window?.rootViewController as? LaunchScreenViewController,
                let imageView = launchScreen.launchScreenOutlet  else {
                return
            }
            
            UIView.animate(withDuration: 1, delay: duration, options: [], animations: {
                imageView.transform = imageView.transform.scaledBy(x: 1.5, y: 1.5)
                imageView.alpha = 0.0
            }, completion: { _ in
                window = nil
            })
        }
    }
    
    fileprivate static func doLocked(_ closure: () -> Void) {
        objc_sync_enter(lock); defer { objc_sync_exit(lock) }
        closure()
    }
    
    
    
    @IBOutlet weak var launchScreenOutlet: UIImageView! {
        didSet {
            launchScreenOutlet.image = UIImage.launchImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }


}
