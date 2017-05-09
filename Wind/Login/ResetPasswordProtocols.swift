//
//  ResetPasswordProtocols.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/9.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift


protocol ResetPasswordAPI {
    func sendVerificationCode(_ phone: String) -> Observable<ValidationResult>
    func reset(_ phone: String, code: String, password: String) -> Observable<ValidationResult>
}


protocol ResetPasswordValidationService {
    func validatePhone(_ phone: String) -> ValidationResult
    func validateCode(_ code: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}
