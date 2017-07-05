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
import RxMediaPicker
import DeviceGuru

fileprivate extension DeviceGuru {
    
    static var isSimulator: Bool {
        return self.hardware() == .simulator
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
    
    fileprivate var mediaPicker: RxMediaPicker!
    fileprivate let imageSubject = Variable(Data())
    fileprivate let agreementSubject = Variable(true)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaPicker = RxMediaPicker(delegate: self)
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
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedUsername
            .drive(usernameOutlet.rx.validationResult)
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordOutlet.rx.validationResult)
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordOutlet.rx.validationResult)
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedCard
            .drive()
            .disposed(by: rx_disposeBag)
        
        viewModel.validatedAgreement
            .drive()
            .disposed(by: rx_disposeBag)
        
        viewModel.signingIn
            .drive(signingUpOulet.rx.isAnimating)
            .disposed(by: rx_disposeBag)
        
        viewModel.signingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx_disposeBag)
        
        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: rx_disposeBag)
        
        
        viewModel.signupEnabled
            .drive(signupOutlet.rx.isEnabled)
            .disposed(by: rx_disposeBag)
        
        agreementOutlet.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let selected = !self.agreementOutlet.isSelected
                self.agreementOutlet.isSelected = selected
                self.agreementSubject.value = selected
            })
            .disposed(by: rx_disposeBag)
        
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
                        return (originImage.io.compress(),editImage?.io.compress())
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
            .disposed(by: rx_disposeBag)
        addImageOutlet.addGestureRecognizer(tapImage)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: rx_disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    private func selectImageForTitle(_ title: String) -> Observable<(UIImage, UIImage?)> {
        if title == "取消" || (DeviceGuru.isSimulator && title == "拍照") {
            return Observable.empty()
        }
        else if title == "拍照" {
            return self.mediaPicker.takePhoto()
        }
        return self.mediaPicker.selectImage()
    }
    

}


extension RegisterViewController: RxMediaPickerDelegate  {

    func present(picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }

    func dismiss(picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
