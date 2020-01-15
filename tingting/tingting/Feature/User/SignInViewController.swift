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
        Logger.info("viewDidLoad")
    }
 
    override func bind() {
        
        signUpButton.rx.tap
            .bind {
                ConnectionManager.shared.signUpRequest = .init()
                ConnectionManager.shared.signUpRequest.local_id = self.emailTextField.text
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
        if ConnectionManager.shared.loadToken() != nil {
            NetworkManager
                .getMyProfile()
                .asObservable()
                .subscribe(
                    onNext: { profile in
                        ConnectionManager.shared.currentUser = profile.myInfo
                        AlertManager.show(title: profile.myInfo.name! + " 님, 오늘은 매칭이 될까요? > <")
                        self.close()
                },
                    onError: { error in
                        AlertManager.showError(error)
                }
            ).disposed(by: disposeBag)
        }
    }
}

extension SignInViewController {
    func signIn() {

        guard let request = getLoginRequest() else { return }
        
        NetworkManager.login(request: request)
            .asObservable()
            .subscribe(
                onNext: { response in
                    ConnectionManager.shared.saveToken(response.token)
                    self.close()
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
