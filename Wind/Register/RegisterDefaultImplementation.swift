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





class Validation {
    
    static let maxUsernameCount = 20
    static let minPasswordCount = 6
    static let maxPasswordCount = 20
    
    static let Mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$"
    
    static let ChinaMobile = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
    
    static let ChinaUnicom = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
    
    static let ChinaTelecom = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
    
    static let PHS = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"

    static let Passwrod = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{\(minPasswordCount),\(maxPasswordCount)}$"
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    class func isPhone(_ string: String) -> Bool {
        let mobile = NSPredicate(format: "SELF MATCHES %@", Mobile)
        let chinaMobile = NSPredicate(format: "SELF MATCHES %@", ChinaMobile)
        let chinaUnicom = NSPredicate(format: "SELF MATCHES %@", ChinaUnicom)
        let chinaTelecom = NSPredicate(format: "SELF MATCHES %@", ChinaTelecom)
        return [mobile,chinaMobile,chinaUnicom,chinaTelecom]
            .map{
                $0.evaluate(with: string)
            }
            .contains(true)
    }
    
    class func isChinaMobile(_ string: String) -> Bool {
        let a = NSPredicate(format: "SELF MATCHES %@", ChinaMobile)
        return a.evaluate(with: string)
    }
    
    class func isChinaUnicom(_ string: String) -> Bool {
        let a = NSPredicate(format: "SELF MATCHES %@", ChinaUnicom)
        return a.evaluate(with: string)
    }
    
    class func isChinaTelecom(_ string: String) -> Bool {
        let a = NSPredicate(format: "SELF MATCHES %@", ChinaTelecom)
        return a.evaluate(with: string)
    }
    
    class func isPHS(_ string: String) -> Bool {
        let a = NSPredicate(format: "SELF MATCHES %@", PHS)
        return a.evaluate(with: string)
    }
    
    class func isPassword(_ string: String) -> Bool {
        let a = NSPredicate(format: "SELF MATCHES %@", Passwrod)
        return a.evaluate(with: string)
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

extension String {
    
    public var isPhone: Bool {
        return Validation.isPhone(self)
    }
    
    public var length: Int {
        return NSString(string: self).length
    }
}


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
            .map{ (response, value) in
               return ValidationResult.parse(response, value: value, generalErrorMessage: registerErrorMessage)
            }
    }
    
}
