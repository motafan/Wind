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
            // this enables using ImageOrientation to "mutate" base type
        }
    }
    
    /// ImageOrientation extensions.
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
    
    
    public enum CompressType {
        case session
        case timeline
    }
    
    /**
     wechat image compress
     
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
    func compress(type: CompressType = .timeline) -> UIImage {
        let size = imageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = UIImageJPEGRepresentation(reImage, 0.5)!
        return UIImage.init(data: data)!
    }
    
    /**
     get wechat compress image size
     
     - parameter type: session  / timeline
     
     - returns: size
     */
    private func imageSize(type: CompressType) -> CGSize {
        var width = base.size.width
        var height = base.size.height
        
        var boundary: CGFloat = 1280
        
        // width, height <= 1280, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1280
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: base.cgImage!, scale: 1, orientation: base.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
