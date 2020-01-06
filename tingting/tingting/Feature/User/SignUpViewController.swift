//
//  SignUpViewController.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {

    @IBOutlet weak var emailTextField: AnimatedTextField!
    @IBOutlet weak var passwordTextField: AnimatedTextField!
    @IBOutlet weak var checkPasswordTextField: AnimatedTextField!
    @IBOutlet weak var duplicationCheckButton: BaseButton!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var isNewID: BehaviorRelay<Bool> = .init(value: false)
    private var isValidated: BehaviorRelay<Bool> = .init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ConnectionManager.shared.signUpRequest.local_id
    }
    
    override func bind() {
        loginButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        isNewID.bind { isNewID in
            self.checkValidation()
            self.checkMarkImageView.isHidden = !isNewID
            self.duplicationCheckButton.isHidden = isNewID
        }.disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent([.editingChanged])
            .compactMap { _ in false }
            .bind(to: isNewID)
            .disposed(by: disposeBag)
        
        duplicationCheckButton
            .rx.tap
            .bind { self.checkDuplicate() }
            .disposed(by: disposeBag)
         
         passwordTextField.rx
             .controlEvent([.editingChanged])
            .bind { self.checkValidation() }
            .disposed(by: disposeBag)
        
        checkPasswordTextField.rx
            .controlEvent([.editingChanged])
            .bind { self.checkValidation() }
            .disposed(by: disposeBag)
        
        isValidated.bind { isValidated in
            self.nextButton.isUserInteractionEnabled = isValidated
            self.nextButton.setBackgroundColor(isValidated: isValidated)
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind {
            ConnectionManager.shared.signUpRequest.local_id = self.emailTextField.text
            ConnectionManager.shared.signUpRequest.password = self.passwordTextField.text
            
            let inputVC = InputProfileViewController.initiate()
            self.navigationController?.pushViewController(inputVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func checkDuplicate() {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            AlertManager.showError("이메일을 입력해주세요")
            return
        }
         
        startLoading(backgroundColor: .clear)
        
        NetworkManager.checkDuplicate(loginID: email)
            .asObservable()
            .subscribe(
                onNext: { response in
                    AlertManager.show(title: response.message)
                    self.isNewID.accept(true)
            },
                onError: { error in
                    AlertManager.showError(error)
                    self.isNewID.accept(false)
            },
                onDisposed:  {
                    self.endLoading()
            }
        ).disposed(by: disposeBag)
    }
    
    func checkValidation() {
        guard let password = passwordTextField.text, password.count >= 8 else {
            isValidated.accept(false)
            return
        }
        
        guard let checkPassword = checkPasswordTextField.text else {
            isValidated.accept(false)
            return
        }
        
        guard checkPassword == password else {
            isValidated.accept(false)
            return
        }
        
        guard isNewID.value else {
            isValidated.accept(false)
            return
        }

        isValidated.accept(true)
    }
    
}

extension SignUpViewController {
    static func initiate() -> SignUpViewController {
        let vc = SignUpViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
