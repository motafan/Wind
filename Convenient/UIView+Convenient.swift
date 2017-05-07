//
//  UIView+Expand.swift
//  Convenient
//
//  Created by Tanfanfan on 2017/1/13.
//  Copyright © 2017年 Tanfanfan. All rights reserved.
//

import UIKit


//protocol NibNamedType {
//    static var nibNamed: String { get }
//}
//
//extension NibNamedType where Self: UIView {
//    static var nibNamed: String {
//        return String(describing: self)
//    }
//}
//
//extension UIView: NibNamedType { }
//
//
//protocol NibCreatable: NibNamedType {
//    init(bundle bundleOrNil: Bundle?) throws
//}
//
//extension NibCreatable where Self: UIView {
//    init(bundle bundleOrNil: Bundle?) throws {
//        let bundle = bundleOrNil ??  Bundle(for: Self.self)
//        guard let view = bundle.loadNibNamed(Self.nibNamed, owner: nil, options: nil)?.last as? Self else {
//            fatalError("Couldn't instantiate view  with nibNamed \(Self.nibNamed) ")
//        }
//        self = view
//    }
//}



@IBDesignable public extension UIView {
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {  return layer.borderWidth }
        set {  layer.borderWidth = newValue }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {  return layer.cornerRadius }
        set {
                layer.cornerRadius = newValue
                masksToBounds = newValue > 0
            }
    }
    
    @IBInspectable public var masksToBounds: Bool {
        get {  return layer.masksToBounds }
        set {  layer.masksToBounds = newValue }
    }
}


public protocol NibCreatable {
    static func createFromNib(owner: Any?) -> Self?
}

public extension NibCreatable where Self: Any {
     public static func createFromNib(owner: Any?) -> Self? {
        let bundleContents = Bundle.main
            .loadNibNamed(nibName, owner: owner, options: nil)
        guard let result = bundleContents?.last as? Self else {
            return nil
        }
        return result
    }
    internal static var nibName: String {
        return String(describing: Self.self)
    }
}

public extension NibCreatable where Self: UIView {
    public static func createAndAdd(to superView: UIView) {
        if let view = createFromNib(owner: nil) {
            superView.addSubview(view)
            // view.backgroundColor = .clear
            // ...
        }
    }
}
