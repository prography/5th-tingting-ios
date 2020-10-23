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
import AuthenticationServices

class SignInViewController: BaseViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var appleButton: BaseButton!
    @IBOutlet weak var kakaoButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        appleButton.rx.tap.bind {
            self.loginForApple()
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
            debugView.isHidden = false
            showDebugView()
        case .live:
            debugView.isHidden = true
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
    
    func loginForApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    func loginForKakao() {
        
//        if AuthController.isTalkAuthAvailable() {
//            AuthController.shared.authorizeWithTalk()
//                .subscribe(onNext:{ oauthToken in
//                    Logger.info(oauthToken)
//                }, onError: { (error) in
//                    print(error)
//                }, onCompleted: {
//                    print("onCompleted")
//                }, onDisposed: {
//                    print("Disposed")
//                })
//                .disposed(by: self.disposeBag)
//        } else {
//            AuthController.shared.authorizeWithAuthenticationSession()
//                .subscribe(onNext:{ oauthToken in
//                    Logger.info(oauthToken)
//                })
//                .disposed(by: self.disposeBag)
//        }
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            print("User: \(user)")
            
            if let email = credential.email {
                print("Email: \(email)")
            }
            
            if let fullName = credential.fullName {
                print("fullName: \(fullName)")
                print("familyName: \(fullName.familyName ?? "")")
                print("givenName: \(fullName.givenName ?? "")")
            }

            guard let identityToken = credential.identityToken, let tokenString = String(data: identityToken, encoding: .utf8) else { return }
            print("Token: \(tokenString)")
        }
    }
}

extension SignInViewController {
    static func initiate() -> SignInViewController {
        let vc = SignInViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
