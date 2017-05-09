//
//  LoginViewController.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/4.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var phoneOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var automaticLoginOutlet: UIButton!
    
    @IBOutlet weak var signinOutlet: UIButton!
    
    @IBOutlet weak var signingInOulet: UIActivityIndicatorView!
    
    @IBOutlet weak var forgotPasswordOutlet: UIButton!
    
    fileprivate let automaticLoginSubject  = Variable(true)

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let viewModel = SigninViewModel(
            input: (
                phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                password: passwordOutlet.rx.text.orEmpty.asDriver(),
                automaticLogin: automaticLoginSubject.asDriver(),
                signinTaps: signinOutlet.rx.tap.asDriver()
            ),
            dependency: (
                API: LoginDefaultAPI.shared,
                validationService: LoginDefaultValidationService.shared,
                wireframe: DefaultWireframe.shared
            )
        )
        
        
        viewModel.validatedPhone
            .debug("validatedPhone")
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedPassword
            .debug("validatedPassword")
            .disposed(by: rx_disposeBag)
        
        automaticLoginOutlet.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let selected = !self.automaticLoginOutlet.isSelected
                self.automaticLoginOutlet.isSelected = selected
                self.automaticLoginSubject.value = selected
            })
            .disposed(by: rx_disposeBag)
        
        viewModel.signingIn
            .drive(signingInOulet.rx.isAnimating)
            .disposed(by: rx_disposeBag)
        
        viewModel.signingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx_disposeBag)
        
        viewModel.signedIn
            .debug("signedIn")
            .disposed(by: rx_disposeBag)
        
        viewModel.signinEnabled
            .drive(signinOutlet.rx.isEnabled)
            .disposed(by: rx_disposeBag)
        
    }
    

}
