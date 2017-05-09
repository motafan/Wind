//
//  ValidationResult.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/8.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}


extension ValidationResult {
    
    static func analysis(_ respnese: HTTPURLResponse, value: Any, generalErrorMessage: String) -> ValidationResult {
        guard let result = value as? [String: Any] else {
            return .failed(message: generalErrorMessage)
        }
        
        guard let code = result[Status.code] as? Int,
            let message =  result[Status.message] as? String else {
                return .failed(message: generalErrorMessage)
        }
        
        if code != Status.success {
            return .failed(message: message)
        }
        return .ok(message: message)
    }
}


struct Status {
    
    static let code = "status"
    
    static let success = 0
    
    static let message = "message"
}



