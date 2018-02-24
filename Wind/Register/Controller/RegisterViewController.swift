//
//  RegisterViewController.swift
//  Wind
//
//  Created by tanfanfan on 2017/4/25.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import NSObject_Rx
import DeviceGuru

fileprivate extension DeviceGuru {
    
    static var isSimulator: Bool {
        return DeviceGuru().hardware() == .simulator
    }
    
}


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneOutlet: UITextField!
    
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    
    @IBOutlet weak var addImageOutlet: UIView!
    
    @IBOutlet weak var cardOutlet: UIImageView!

    @IBOutlet weak var agreementOutlet: UIButton!
    
    @IBOutlet weak var signupOutlet: UIButton!
    
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!
    
    fileprivate let imageSubject = Variable(Data())
    fileprivate let agreementSubject = Variable(true)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        let viewModel = SignupViewModel(
            input: (
                phone: phoneOutlet.rx.text.orEmpty.asDriver(),
                username: usernameOutlet.rx.text.orEmpty.asDriver(),
                password: passwordOutlet.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
                card: imageSubject.asDriver(),
                agreement: agreementSubject.asDriver(),
                signupTaps: signupOutlet.rx.tap.asDriver()
            ),
            dependency: (
                API: RegisterDefaultAPI.shared,
                validationService: RegisterDefaultValidationService.shared,
                wireframe: DefaultWireframe.shared
            )
        )
        
        
        viewModel.validatedPhone
            .drive(phoneOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedUsername
            .drive(usernameOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordOutlet.rx.validationResult)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedCard
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        viewModel.validatedAgreement
            .drive()
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signingIn
            .drive(signingUpOulet.rx.isAnimating)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: self.rx.disposeBag)
        
        
        viewModel.signupEnabled
            .drive(signupOutlet.rx.isEnabled)
            .disposed(by: self.rx.disposeBag)
        
        agreementOutlet.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let selected = !self.agreementOutlet.isSelected
                self.agreementOutlet.isSelected = selected
                self.agreementSubject.value = selected
            })
            .disposed(by: self.rx.disposeBag)
        
        let tapImage = UITapGestureRecognizer()
        tapImage.rx.event
            .asDriver()
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .flatMapLatest { _ -> Driver<(UIImage, UIImage?)> in
                return DefaultWireframe.shared.guidanceFor(cancelAction: "取消", actions: ["拍照","相册"])
                    .flatMapLatest { title  -> Observable<(UIImage, UIImage?)> in
                        return self.selectImageForTitle(title)
                    }
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
                    .map{ pair -> (UIImage, UIImage?) in
                        let (originImage, editImage) = pair
                        return (originImage.io.compress(), editImage?.io.compress())
                    }
                    .asDriver(onErrorJustReturn: (UIImage(), nil))
            }
            .map { pair -> (UIImage, Data) in
                let (originImage, editImage) = pair
                let image = editImage ?? originImage
                let data = image.kf.pngRepresentation() ?? Data()
                return (image, data)
            }
            .drive(onNext: { pair in
                let (image, data) = pair
                self.cardOutlet.image = image
                self.imageSubject.value = data
            })
            .disposed(by: self.rx.disposeBag)
        addImageOutlet.addGestureRecognizer(tapImage)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: self.rx.disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    private func selectImageForTitle(_ title: String) -> Observable<(UIImage, UIImage?)> {
        if title == "取消" || (DeviceGuru.isSimulator && title == "拍照") {
            return Observable.error(CameraError.simulator)
        }
        
        var sourceType: UIImagePickerControllerSourceType  = .photoLibrary
        if title == "拍照" {
            sourceType = .camera
        }
        return UIImagePickerController.rx.createWithParent(self, animated: true){ picker in
                picker.sourceType = sourceType
                picker.allowsEditing = false
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .map({ info  in
                return (info[UIImagePickerControllerOriginalImage] as! UIImage, info[UIImagePickerControllerEditedImage] as? UIImage)
            })
    }
}


enum CameraError: String, Swift.Error {
    case simulator = "The simulator does not support collection!"
}

