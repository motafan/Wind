//
//  LoginDefaultImplementation.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/8.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire


class LoginDefaultAPI: LoginAPI {

    static let shared  = LoginDefaultAPI()
    
    func signin(_ phone: String, password: String, automaticLogin: Bool) -> Observable<ValidationResult> {
        
        let url = "http://mqaa.emoney.cn//mobile/Identity/Login"
        let parameters = ["Username": phone, "Password": password, "RememberMe": automaticLogin.description]
        
        return RxAlamofire.requestJSON(.post, url, parameters: parameters)
            .debug()
            .map { (arg) -> ValidationResult in
                let (response, value) = arg
                return ValidationResult.parse(response, value: value, generalErrorMessage: loginErrorMessage)
            }
    }
}

class LoginDefaultValidationService: LoginValidationService {
    
    static let shared  = LoginDefaultValidationService()
    
    func validatePhone(_ phone: String) -> ValidationResult {
        
        if phone.isEmpty {
            return .empty
        }
        
        return .ok(message: "Phone acceptable")
    }

    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.length
        if numberOfCharacters == 0 {
            return .empty
        }
        
        return .ok(message: "Password acceptable")
    }
}
