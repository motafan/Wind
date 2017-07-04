//
//  RegisterDefaultValidationService.swift
//  Wind
//
//  Created by tanfanfan on 2017/4/25.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire
import Kingfisher
import RxAlamofire


class RegisterDefaultValidationService: RegisterValidationService {
    
    static let shared  = RegisterDefaultValidationService()
    
    func validatePhone(_ phone: String) -> ValidationResult {
        return ValidationManager.validatePhone(phone)
    }
    
    func validateUsername(_ username: String) -> ValidationResult {
        
        if username.isEmpty {
            return .empty
        }
        
        if username.length > Validation.maxUsernameCount {
            return .failed(message: "Username must be at least \(Validation.maxUsernameCount) characters")
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .failed(message: "Username can only contain numbers or digits")
        }
        return .ok(message: "Username acceptable")
    }
    
    
    func validatePassword(_ password: String) -> ValidationResult {
        return ValidationManager.validatePassword(password)
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        return ValidationManager.validateRepeatedPassword(password,repeatedPassword: repeatedPassword)
    }
    
    func validateCard(_ card: Data) -> ValidationResult {
        if card.isEmpty {
            return .empty
        }
        return .ok(message: "Card acceptable")
    }
    
    func validateAgreement(_ agreement: Bool) -> ValidationResult {
        if !agreement {
            return .failed(message: "Agreement must be checked")
        }
        
        return .ok(message: "Agreement acceptable")
    }
    
}


class RegisterDefaultAPI: RegisterAPI {
    
    static let shared  = RegisterDefaultAPI()
    
    func signup(_ phone: String, username: String, password: String, card: Data) -> Observable<ValidationResult> {
        let url = "http://mqaa.emoney.cn/mobile/Identity/Register"
        let parameters = [
            "Username":phone,
            "NikeName": username,
            "Password": password,
            "ConfirmPassword": password,
            "Avatar": card.base64EncodedString()
        ]
        return RxAlamofire
            .requestJSON(.post, url, parameters: parameters)
            .debug()
            .map({ (pair) -> ValidationResult in
                let (response, value) = pair
                return ValidationResult.parse(response, value: value, generalErrorMessage: registerErrorMessage)
            })
    }
    
}
