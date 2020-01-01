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
                let emailVC = EmailAuthenticationViewController.initiate()
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
        close()
    }
}

extension SignInViewController {
    static func initiate() -> SignInViewController {
        
        let vc = SignInViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
