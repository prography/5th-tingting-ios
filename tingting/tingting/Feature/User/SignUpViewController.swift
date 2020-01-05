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
    
    private var isNewID: PublishRelay<Bool> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkImageView.isHidden = true
        duplicationCheckButton.isHidden = false
        
    }
    
    override func bind() {
        loginButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        isNewID.bind { isNewID in
            
            guard let text = self.emailTextField.text, !text.isEmpty else {
                self.checkMarkImageView.isHidden = true
                self.duplicationCheckButton.isHidden = false
                return
            }
            
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
                    self.checkMarkImageView.isHidden = false
                    self.duplicationCheckButton.isHidden = true
            },
                onError: { error in
                    AlertManager.showError(error)
            },
                onDisposed:  {
                    self.endLoading()
            }
        ).disposed(by: disposeBag)
    }
    
}

extension SignUpViewController {
    static func initiate() -> SignUpViewController {
        let vc = SignUpViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
