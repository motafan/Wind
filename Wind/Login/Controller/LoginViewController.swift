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
            .drive()
            .disposed(by: disposeBag)
        
        viewModel.validatedPassword
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        automaticLoginOutlet.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let selected = !self.automaticLoginOutlet.isSelected
                self.automaticLoginOutlet.isSelected = selected
                self.automaticLoginSubject.value = selected
            })
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signingIn
            .drive(signingInOulet.rx.isAnimating)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signedIn
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signinEnabled
            .drive(signinOutlet.rx.isEnabled)
            .disposed(by: self.rx.disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: self.rx.disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
}
