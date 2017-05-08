//
//  UIImage+Orientation.swift
//  Wind
//
//  Created by tanfanfan on 2017/4/27.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public struct ImageOrientation<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has ImageOrientation extensions.
public protocol ImageOrientationCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// ImageOrientation extensions.
    static var io: ImageOrientation<CompatibleType>.Type { get set }
    
    /// ImageOrientation extensions.
    var io: ImageOrientation<CompatibleType> { get set }
}

extension ImageOrientationCompatible {
    /// ImageOrientation extensions.
    public static var io: ImageOrientation<Self>.Type {
        get {
            return ImageOrientation<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    /// Reactive extensions.
    public var io: ImageOrientation<Self> {
        get {
            return ImageOrientation(self)
        }
        set {
            // this enables using ImageOrientation to "mutate" base object
        }
    }
}



/// Extend NSObject with `io` proxy.
extension NSObject: ImageOrientationCompatible { }

//http://blog.csdn.net/hitwhylz/article/details/39518463#comments
extension ImageOrientation where Base: UIImage {
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        
        switch base.imageOrientation {
        case .up:
            return base
        case .down:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .left)
        case .left,.right:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .up)
        case .upMirrored:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .leftMirrored)
        case .downMirrored:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .rightMirrored)
        case .leftMirrored:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .downMirrored)
        case .rightMirrored:
            return UIImage(cgImage: base.cgImage!, scale: base.scale, orientation: .upMirrored)
        }
        
    }
    
}
