//
//  ResetPasswordDefaultImplementation.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/9.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire


class ResetPasswordDefaultAPI: ResetPasswordAPI {
    
    static let share = ResetPasswordDefaultAPI()
    
    func reset(_ phone: String, code: String, password: String) -> Observable<ValidationResult> {
        let url = "http://mqaa.emoney.cn/mobile/Identity/RestPasswordWithForgot"
        let parameters = ["mobile": phone, "smsCode": code, "newPassword": password, "newPassword2": password]
        return RxAlamofire.requestJSON(.post, url, parameters: parameters)
            .debug()
            .map{ (response, value) in
                return ValidationResult.analysis(response, value: value, generalErrorMessage: "Reset password failed")
            }
        
    }

    func sendVerificationCode(_ phone: String) -> Observable<ValidationResult> {
        let url = "http://mqaa.emoney.cn//mobile/Identity/SendForgotPasswordSmsCode"
        let parameters = ["mobile": phone]
        return RxAlamofire.requestJSON(.post, url, parameters: parameters)
            .debug()
            .map{ (response, value) in
               return ValidationResult.analysis(response, value: value, generalErrorMessage: "Send code failed")
            }
    }

    
}


class ResetPasswordDefaultValidationService: ResetPasswordValidationService {
    
    static let share = ResetPasswordDefaultValidationService()
    
    func validatePhone(_ phone: String) -> ValidationResult {
        return ValidationManager.validatePhone(phone)
    }
    
    func validateCode(_ code: String) -> ValidationResult {
        if code.isEmpty {
            return .empty
        }
        
        return .ok(message: "Code acceptable")
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        return ValidationManager.validatePassword(password)
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        return ValidationManager.validateRepeatedPassword(password, repeatedPassword: repeatedPassword)
    }
    
}
