//
//  SigninViewModel.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/8.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities

class SigninViewModel {
    
    let validatedPhone: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    
    let signinEnabled: Driver<Bool>
    let signedIn: Driver<Bool>
    let signingIn: Driver<Bool>
    
    init(
        input:(
            phone: Driver<String>,
            password: Driver<String>,
            automaticLogin: Driver<Bool>,
            signinTaps: Driver<Void>
        ),
        dependency: (
            API: LoginAPI,
            validationService: LoginValidationService,
            wireframe: Wireframe
        )
    ) {
        
        
        let API = dependency.API
        
        let validationService = dependency.validationService
        
        let wireframe = dependency.wireframe
        
        validatedPhone = input.phone
            .map { phone -> ValidationResult in
                return validationService.validatePhone(phone)
            }
        
        validatedPassword = input.password
            .map { password -> ValidationResult in
                return validationService.validatePassword(password)
            }
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let signinInfo = Driver.combineLatest(input.phone, input.password, input.automaticLogin){ ($0, $1, $2) }
        
        signedIn = input.signinTaps.withLatestFrom(signinInfo)
            .flatMapLatest { (arg) -> Driver<ValidationResult> in
                let (phone, password, automaticLogin) = arg
                return API.signin(phone, password: password, automaticLogin: automaticLogin)
                    .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: .failed(message: loginErrorMessage))
            }
            .flatMapLatest{ signingIn -> Driver<Bool> in
                let message = signingIn.description
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _  in
                        return signingIn.isValid
                    }
                    .asDriver(onErrorJustReturn: false)
            }

        
        
        signinEnabled = Driver.combineLatest(
            validatedPhone,
            validatedPassword,
            signingIn.asDriver()
        )   { phone, password, signingIn  in
                phone.isValid &&
                password.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
    
    }
    
}
