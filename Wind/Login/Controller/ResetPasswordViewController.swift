//
//  ResetPasswordViewController.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/9.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ResetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var phoneOutlet: UITextField!
    
    @IBOutlet weak var codeOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    
    @IBOutlet weak var sendCodeOutlet: UIButton!
    
    @IBOutlet weak var resetOutlet: UIButton!
    
    @IBOutlet weak var resetingInOulet: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let viewModel = ResetPasswordViewModel(
            input: (
                phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                code: codeOutlet.rx.text.orEmpty.asDriver(),
                password: passwordOutlet.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
                sendCodeTaps: sendCodeOutlet.rx.tap.asDriver(),
                resetPasswordTaps: resetOutlet.rx.tap.asDriver()
            ),
            dependency: (
                API: ResetPasswordDefaultAPI.share,
                validationService: ResetPasswordDefaultValidationService.share,
                wireframe: DefaultWireframe.shared
            )
        )
        
        viewModel.validatedPhone
            .drive(phoneOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedCode
            .drive(codeOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.resetingIn
            .drive(resetingInOulet.rx.isAnimating)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.resetingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.sendingIn
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        viewModel.resetIn
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        viewModel.sendCodeEnabled
            .drive(sendCodeOutlet.rx.isEnabled)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.resetPasswowrdEnabled
            .drive(resetOutlet.rx.isEnabled)
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
