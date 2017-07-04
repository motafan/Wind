//
//  Validation.swift
//  Wind
//
//  Created by 谭帆帆 on 2017/7/4.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

extension String {
    
    public var isPhone: Bool {
        return Validation.isPhone(self)
    }
    
    public var length: Int {
        return NSString(string: self).length
    }
}

class Validation {
    
    static let maxUsernameCount = 20
    static let minPasswordCount = 6
    static let maxPasswordCount = 20
    
    enum Regular: String {
        case mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$"
        case chinaMobile = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        case chinaUnicom = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        case chinaTelecom = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        case phs = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
        case passwrod =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
    }
    
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    class func isPhone(_ string: String) -> Bool {
        return verify(string, .mobile,.chinaMobile,.chinaUnicom,.chinaTelecom)
    }
    
    class func isChinaMobile(_ string: String) -> Bool {
        return verify(string, .chinaMobile)
    }
    
    class func isChinaUnicom(_ string: String) -> Bool {
        return verify(string, .chinaUnicom)
    }
    
    class func isChinaTelecom(_ string: String) -> Bool {
        return verify(string, .chinaTelecom)
    }
    
    class func isPHS(_ string: String) -> Bool {
        return verify(string, .phs)
    }
    
    class func isPassword(_ string: String) -> Bool {
        return verify(string, .passwrod)
    }
    
    private class func verify(_ string: String, _ regulars: Regular...) -> Bool {
        return regulars
            .map {
                return $0.rawValue
            }
            .map {
                return NSPredicate(format: "SELF MATCHES %@", $0).evaluate(with: string)
            }
            .contains(true)
    }
}


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
        let numberOfCharacters = password.characters.count
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
