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

    @IBOutlet weak var userIDTextField: AnimatedTextField!
    @IBOutlet weak var passwordTextField: AnimatedTextField!
    @IBOutlet weak var checkPasswordTextField: AnimatedTextField!
    @IBOutlet weak var duplicationCheckButton: BaseButton!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var isNewID: BehaviorRelay<Bool> = .init(value: false)
    private var isValid: BehaviorRelay<Bool> = .init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.text = ConnectionManager.shared.signUpRequest.local_id
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
        
        userIDTextField.rx.controlEvent([.editingChanged])
            .bind { [weak self] in
                let text = self?.userIDTextField.text?.filterString(regex: "[0-9a-zA-Z]+") ?? ""
                self?.userIDTextField.text = text.count > 20 ? text[0..<20] : text
                self?.isNewID.accept(false)
                
        }.disposed(by: disposeBag)
        
        duplicationCheckButton
            .rx.tap
            .bind { self.checkDuplicate() }
            .disposed(by: disposeBag)
         
         passwordTextField.rx
             .controlEvent([.editingChanged])
            .bind { [weak self] in
                self?.changeTextFieldColor()
                self?.checkValidation()
                
         }
            .disposed(by: disposeBag)
        
        checkPasswordTextField.rx
            .controlEvent([.editingChanged])
            .bind { [weak self] in
                self?.changeTextFieldColor()
                self?.checkValidation()
        }.disposed(by: disposeBag)
        
        isValid
            .bind(onNext: nextButton.setEnable)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind {
            ConnectionManager.shared.signUpRequest.local_id = self.userIDTextField.text
            ConnectionManager.shared.signUpRequest.password = self.passwordTextField.text
            
            let inputVC = InputProfileViewController.initiate()
            self.navigationController?.pushViewController(inputVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func checkDuplicate() {
        
        guard let userID = userIDTextField.text, !userID.isEmpty else {
            AlertManager.showError("아이디을 입력해주세요")
            return
        }
         
        startLoading(backgroundColor: .clear)
        
        NetworkManager.checkDuplicate(loginID: userID)
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
            isValid.accept(false)
            return
        }
        
        guard let checkPassword = checkPasswordTextField.text else {
            isValid.accept(false)
            return
        }
        
        guard checkPassword == password else {
            isValid.accept(false)
            return
        }
        
        guard isNewID.value else {
            isValid.accept(false)
            return
        }

        isValid.accept(true)
    }
    
    func changeTextFieldColor() {

        let text = passwordTextField.text ?? ""
        passwordTextField.borderColor = (1...8).contains(text.count) ? .red : .primary
 
        let checkText = checkPasswordTextField.text ?? ""
        let isSameOrEmpty = text == checkText || checkText.isEmpty
        checkPasswordTextField.borderColor = isSameOrEmpty ? .primary : .red
    }
    
}

extension SignUpViewController {
    static func initiate() -> SignUpViewController {
        let vc = SignUpViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
