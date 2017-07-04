//
//  LoginProtocols.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/8.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//


import RxSwift

let loginErrorMessage = "Login failed"

protocol LoginAPI {
    func signin(_ phone: String, password: String, automaticLogin: Bool) -> Observable<ValidationResult>
}

protocol LoginValidationService {
    func validatePhone(_ phone: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}
