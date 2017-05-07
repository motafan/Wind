//
//  BindingExtensions.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/3.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa


extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.clear
        case .validating:
            return UIColor.orange
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

extension Reactive where Base: UITextField {
    var validationResult: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.textColor = result.textColor
        }
    }
}
