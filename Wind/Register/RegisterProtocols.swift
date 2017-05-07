//
//  RegisterProtocols.swift
//  Wind
//
//  Created by tanfanfan on 2017/4/25.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

enum SignupState {
    case signedUp(signedUp: Bool)
}


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

struct StatusCode {
    
    static let status = "status"
    
    static let success = 0
}



protocol RegisterAPI {
    func signup(_ phone: String, username: String, password: String, card: Data) -> Observable<Bool>
}

protocol RegisterValidationService {
    func validatePhone(_ phone: String) -> ValidationResult
    func validateUsername(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
    func validateCard(_ card: Data) -> ValidationResult
    func validateAgreement(_ agreement: Bool) -> ValidationResult
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
