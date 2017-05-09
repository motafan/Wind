//
//  ResetPasswordViewModel.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/9.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities


class ResetPasswordViewModel {
    
    let validatedPhone: Driver<ValidationResult>
    let validatedCode: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    let resetPasswowrdEnabled: Driver<Bool>
    let sendCodeEnabled: Driver<Bool>
    let resetIn: Driver<Bool>
    let sendingIn: Driver<Bool>
    // Is signing process in progress
    let resetingIn: Driver<Bool>
    
    
    init(
        input:(
            phone: Driver<String>,
            code: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            sendCodeTaps: Driver<Void>,
            resetPasswordTaps: Driver<Void>
        ),
        dependency: (
            API: ResetPasswordAPI,
            validationService: ResetPasswordValidationService,
            wireframe: Wireframe
        )
    ) {
        
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        validatedPhone = input.phone.map{ phone in
            return validationService.validatePhone(phone)
        }
        
        validatedCode = input.code.map{ code  in
            return validationService.validateCode(code)
        }
        
        validatedPassword = input.password.map{ password  in
            return validationService.validatePassword(password)
        }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        
        sendingIn = input.sendCodeTaps.withLatestFrom(input.phone)
            .flatMapLatest { phone -> Driver<ValidationResult> in
                return API.sendVerificationCode(phone).asDriver(onErrorJustReturn: .failed(message: "Send code failed"))
            }
            .flatMapLatest { validation -> Driver<Bool> in
                return wireframe
                    .promptFor(validation.description, cancelAction: "OK", actions: [])
                    .map { _ -> Bool in
                        return validation.isValid
                    }
                    .asDriver(onErrorJustReturn: false)
            }
    
            let signingIn = ActivityIndicator()
            self.resetingIn = signingIn.asDriver()
            
            let resetInfo = Driver.combineLatest(input.phone, input.code, input.password, input.repeatedPassword) { ($0, $1, $2, $3) }
        
            resetIn = input.resetPasswordTaps.withLatestFrom(resetInfo)
                .flatMapLatest{ (phone, code, password, _) -> Driver<ValidationResult> in
                    return API.reset(phone, code: code, password: password)
                        .trackActivity(signingIn)
                        .asDriver(onErrorJustReturn: .failed(message: "Reset password failed"))
                }
                .flatMapLatest{ validationResult -> Driver<Bool> in
                    return wireframe
                        .promptFor(validationResult.description, cancelAction: "OK", actions: [])
                        .map { _  in
                            return validationResult.isValid
                        }
                        .asDriver(onErrorJustReturn: false)
                }
        
        
            resetPasswowrdEnabled =  Driver.combineLatest(validatedPhone,validatedCode, validatedPassword, validatedPasswordRepeated, signingIn.asDriver()) { (phone, code, password, passwordRepeated, signingIn) -> Bool in
                return phone.isValid && code.isValid && password.isValid && passwordRepeated.isValid && !signingIn
            }
        
            sendCodeEnabled = validatedPhone.map{ $0.isValid }
        
        }
    
}
    
        

        
        
        
        
        
        
