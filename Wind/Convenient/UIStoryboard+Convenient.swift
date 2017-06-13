//
//  UIStoryboard+Expand.swift
//  Convenient
//
//  Created by Tanfanfan on 2017/1/13.
//  Copyright © 2017年 Tanfanfan. All rights reserved.
//

import UIKit

public protocol StoryboardIdentifiableType {
    static var storyboardIdentifiable: String { get }
}

extension StoryboardIdentifiableType where Self: UIViewController {
    public static var storyboardIdentifiable: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiableType { }

public extension UIStoryboard {
    
    public enum Storyboard: String {
        case Main
    }
    
    public convenience init(storyboard: Storyboard, bundle bundleOrNil: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundleOrNil)
    }
    
    public class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    public func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifiable) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifiable) ")
        }
        return viewController
    }
}





