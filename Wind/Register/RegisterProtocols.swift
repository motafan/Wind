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



enum SignupState {
    case signedUp(signedUp: Bool)
}


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}





protocol RegisterAPI {
    func signup(_ phone: String, username: String, password: String, card: Data) -> Observable<ValidationResult>
}

protocol RegisterValidationService {
    func validatePhone(_ phone: String) -> ValidationResult
    func validateUsername(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
    func validateCard(_ card: Data) -> ValidationResult
    func validateAgreement(_ agreement: Bool) -> ValidationResult
}
