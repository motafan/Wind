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
    
    init(input:(
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
        
        validatedPhone = input.phone.map{ phone -> ValidationResult in
            return validationService.validatePhone(phone)
        }
        
        validatedPassword = input.password.map{ password -> ValidationResult in
            return validationService.validatePassword(password)
        }
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let signinInfo = Driver.combineLatest(input.phone, input.password,input.automaticLogin){
            return ($0, $1,$2)
        }
        
        signedIn = input.signinTaps.withLatestFrom(signinInfo)
            .flatMapLatest { (phone,password,automaticLogin) -> Driver<ValidationResult> in
                return API.signin(phone, password: password, automaticLogin: automaticLogin)
                    .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: .failed(message: "Mock: Sign in to Wind failed"))
            }
            .flatMapLatest{ signingIn -> Driver<Bool> in
                let message = signingIn.description
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map{ _  in
                        return signingIn.isValid
                    }
                    .asDriver(onErrorJustReturn: false)
            }

        
        
        signinEnabled = Driver.combineLatest(validatedPhone, validatedPassword){ (phone, password)  in
                return phone.isValid && password.isValid
            }
            .distinctUntilChanged()
    
    }
    
}
