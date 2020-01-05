//
//  SignInViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        Logger.info("viewDidLoad")
    }
 
    override func bind() {
        
        signUpButton.rx.tap
            .bind {
                let emailVC = SignUpViewController.initiate()
                let naviVC = BaseNavigationController(rootViewController: emailVC)
                self.present(naviVC, animated: true)
        }.disposed(by: disposeBag)
        
        signInButton.rx.tap.bind {
            self.signIn()
        }.disposed(by: disposeBag)
        
 
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension SignInViewController {
    func signIn() {

        guard let request = getLoginRequest() else { return }
        
        NetworkManager.login(request: request)
            .asObservable()
            .subscribe(
                onNext: { response in
                    ConnectionManager().saveToken(response.token)
            },
                onError: { error in
                    AlertManager.showError(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func getLoginRequest() -> APIModel.Login.Request? {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            AlertManager.showError("이메일을 입력해주세요.")
            return nil
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            AlertManager.showError("비밀번호를 입력해주세요")
            return nil
        }
        
        return APIModel.Login.Request(id: email, password: password)
    }
}

extension SignInViewController {
    static func initiate() -> SignInViewController {
        
        let vc = SignInViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
