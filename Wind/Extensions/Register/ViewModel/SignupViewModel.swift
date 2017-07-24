//
//  SignupViewModel.swift
//  Wind
//
//  Created by tanfanfan on 2017/4/25.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftUtilities

class SignupViewModel {
    
    let validatedPhone: Driver<ValidationResult>
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    let validatedCard: Driver<ValidationResult>
    let validatedAgreement: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    let signedIn: Driver<Bool>
    // Is signing process in progress
    let signingIn: Driver<Bool>
    
    init(
        input:(
            phone: Driver<String>,
            username: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            card: Driver<Data>,
            agreement: Driver<Bool>,
            signupTaps: Driver<Void>
        ),
        dependency: (
            API: RegisterAPI,
            validationService: RegisterValidationService,
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
        
        validatedUsername = input.username
            .map { username -> ValidationResult in
                return validationService.validateUsername(username)
            }
        
        validatedPassword = input.password
            .map { password -> ValidationResult in
               return validationService.validatePassword(password)
            }
        
        validatedPasswordRepeated  = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        validatedCard = input.card
            .map { card -> ValidationResult in
               return validationService.validateCard(card)
            }
        
        validatedAgreement = input.agreement
            .map { agreement -> ValidationResult in
                return validationService.validateAgreement(agreement)
            }
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let inputInfo = Driver.combineLatest(input.phone, input.username, input.password, input.card) { ($0, $1, $2, $3) }
        self.signedIn = input.signupTaps.withLatestFrom(inputInfo)
            .flatMapLatest({ (arg) -> SharedSequence<DriverSharingStrategy, ValidationResult> in
                let (phone, username, password, card) = arg
                return API.signup(phone, username: username, password: password, card: card)
                    .trackActivity(signingIn).asDriver(onErrorJustReturn: .failed(message: registerErrorMessage))
            })
            .flatMapLatest { signingIn -> Driver<Bool> in
                let message = signingIn.description
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        signingIn.isValid
                    }
                    .asDriver(onErrorJustReturn: false)
            }
        
        signupEnabled = Driver.combineLatest(
            validatedPhone,
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            validatedCard,
            validatedAgreement,
            signingIn.asDriver()
        )   { phone, username, password, passwordRepeated, card, agreement, signingIn in
                phone.isValid &&
                username.isValid &&
                password.isValid &&
                passwordRepeated.isValid &&
                card.isValid &&
                agreement.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
        
    }
    
}
