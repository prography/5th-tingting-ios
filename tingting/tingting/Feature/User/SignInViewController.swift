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
import RxKakaoSDKCommon
import RxKakaoSDKAuth

class SignInViewController: BaseViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var kakaoButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch CURRENT_SERVER {
        case .debug:
            headerView.backgroundColor = .gray
        case .live:
            headerView.backgroundColor = .primary
        }
        
        Logger.info("viewDidLoad")
    }
 
    override func bind() {
        signUpButton.rx.tap
            .bind {
                ConnectionManager.shared.signUpRequest = .init()
                ConnectionManager.shared.signUpRequest.local_id = self.emailTextField.text
                let termsVC = TermsViewController.initiate()
                let naviVC = BaseNavigationController(rootViewController: termsVC)
                // naviVC.modalPresentationStyle = .fullScreen
                self.present(naviVC, animated: true)
        }.disposed(by: disposeBag)
        
        signInButton.rx.tap.bind {
            self.signIn()
        }.disposed(by: disposeBag)
 
        kakaoButton.rx.tap.bind {
            self.loginForKakao()
        }.disposed(by: disposeBag)
 
        Observable
            .of(emailTextField.rx.controlEvent([.editingChanged]), passwordTextField.rx.controlEvent([.editingChanged]))
            .merge()
            .bind { [weak self] in
                guard let self = self else { return }
                guard self.passwordTextField.text == "191005" else { return }
                switch self.emailTextField.text {
                case "@@live":
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.changeServer(with: .live)
                    
                case "@@dev":
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.changeServer(with: .debug)
                    
                default:
                    break
                } 
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
    
    func changeServer(with type: ServerType) {
        
        CURRENT_SERVER = type
         
        switch type {
        case .debug:
            UIColor.primary = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .live:
            UIColor.primary = #colorLiteral(red: 1, green: 0.5744549632, blue: 0.5127008557, alpha: 1)
        }
        headerView.backgroundColor = .primary
        
    }
    
    func signIn() {

        guard let request = getLoginRequest() else { return }
        
        NetworkManager.login(request: request)
            .asObservable()
            .subscribe(
                onNext: { response in
                    
                    ConnectionManager.shared.saveToken(response.token)
                    
                    NetworkManager.getMyProfile()
                        .asObservable()
                        .subscribe(
                            onNext: { myProfile in
                                ConnectionManager.shared.currentUser = myProfile.myInfo
                                self.close()
                        },
                            onError: { error in
                                AlertManager.showError(error)
                        }
                    ).disposed(by: self.disposeBag)
                    
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
    
    func loginForKakao() {
        if AuthController.isTalkAuthAvailable() {
            AuthController.shared.authorizeWithTalk()
                .subscribe(onNext:{ (oauthToken) in
                    print(oauthToken)
                })
                .disposed(by: self.disposeBag)
        } else {
            AuthController.shared.authorizeWithAuthenticationSession()
                .subscribe(onNext:{ (oauthToken) in
                    print(oauthToken)
                })
                .disposed(by: self.disposeBag)
        }
    }
}

extension SignInViewController {
    static func initiate() -> SignInViewController {
        
        let vc = SignInViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
