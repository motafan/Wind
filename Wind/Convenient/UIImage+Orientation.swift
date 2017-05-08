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
    
    func fixOrientation() -> UIImage? {
        
        // No-op if the orientation is already correct
        if case .up = base.imageOrientation {
             return base
        }
        
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = .identity
        
        switch self.base.imageOrientation {
        case .down,.downMirrored:
            transform = transform
                .translatedBy(x: base.size.width, y: base.size.height)
                .rotated(by: CGFloat.pi)
        case .left,.leftMirrored:
            transform = transform
                .translatedBy(x: base.size.width, y: 0)
                .rotated(by:.pi / 2)
        case .right,.rightMirrored:
            transform = transform
                .translatedBy(x: 0, y: base.size.height)
                .rotated(by: -CGFloat.pi / 2)
        default:
            break
        }
        
        switch base.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform
                .translatedBy(x: base.size.width, y: 0)
                .scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform
                .translatedBy(x: base.size.height, y: 1)
                .scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let cgImage = base.cgImage else {
            return nil
        }
        
        let w = Int(base.size.width)
        let h =  Int(base.size.height)
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow =  0
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.bitmapInfo
        
        guard let context = CGContext(data: nil,
                                width: w,
                                height: h,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue) else
        {
                return nil
        }
        context.concatenate(transform)
        switch base.imageOrientation {
        case .left,.leftMirrored,.right,.rightMirrored:
            context.draw(base.cgImage!, in: CGRect(x: 0, y: 0, width: base.size.height, height: base.size.width))
        default:
            context.draw(base.cgImage!, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        }
        
        return context.makeImage().flatMap{ UIImage(cgImage: $0) }
    }
    
}
