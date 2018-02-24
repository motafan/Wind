//
//  ValidationManager.swift
//  Wind
//
//  Created by 谭帆帆 on 2017/7/5.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

class ValidationManager {
    
    class func validatePhone(_ phone: String) -> ValidationResult {
        
        if phone.isEmpty {
            return .empty
        }
        
        if phone.length != 11 {
            return .failed(message: "Phone must be equls 11 characters")
        }
        
        if !phone.isPhone {
            return .failed(message: "Phone failed")
        }
        return .ok(message: "Phone acceptable")
    }
    
    class func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters =  password.length
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < Validation.minPasswordCount || numberOfCharacters > Validation.maxPasswordCount {
            return .failed(message: "Password must be at range [\(Validation.minPasswordCount)-\(Validation.maxPasswordCount)]characters")
        }
        
        
        if !Validation.isPassword(password) {
            return .failed(message: "Password must contain letters and numbers")
        }
        return .ok(message: "Password acceptable")
    }
    
    class func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.isEmpty {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
}
