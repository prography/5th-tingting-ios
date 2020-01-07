//
//  EmailAuthenticationViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmailAuthenticationViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var nextButton: UIButton!
    
    private var nickname: String = ""
    
    private let isValid: BehaviorRelay<Bool> = .init(value: false)
    private let emailProperty: PublishRelay<String?> = .init()
    
    var emailDriver: Driver<String?> {
         return emailProperty.asDriver(onErrorJustReturn: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func bind() {
        
        emailTextField.rx
            .controlEvent([.editingChanged])
            .bind {
                let email = self.emailTextField.text
                let isValid = Validator.check(email: email)
                self.sendButton.setEnable(isValid)
                self.isValid.accept(false)
        }.disposed(by: disposeBag)
          
        sendButton.rx.tap
            .bind(onNext: authenticateSchool)
            .disposed(by: disposeBag)
        
        isValid
            .bind(onNext: nextButton.setEnable)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(onNext: confirmSchool)
            .disposed(by: disposeBag)
    }
    
    func authenticateSchool() {
        let request = APIModel.School.Request(name: self.nickname,
                                              email: self.emailTextField.text!)
        
        NetworkManager.authenticateSchool(request: request)
            .asObservable()
            .subscribe(
                onNext: { response in
                    AlertManager.show(title: response.message)
                    self.nextButton.setEnable(true)
            },
                onError: { error in
                    AlertManager.showError(error)
                    self.isValid.accept(false)
            }
        ).disposed(by: self.disposeBag)
    }
    
    func confirmSchool() {
        guard let email = emailTextField.text else {
            assertionFailure("Email must exist.")
            return
        }
        NetworkManager.authenticateSchoolComplete(email: email)
            .asObservable()
            .subscribe(
                onNext: { response in
                    AlertManager.show(title: response.message)
                    self.emailProperty.accept(email)
            },
                onError: { error in
                    AlertManager.showError(error)
            }
        ).disposed(by: disposeBag)
    }
    
}

extension EmailAuthenticationViewController {
    static func initiate(nickname: String) -> EmailAuthenticationViewController {
        
        let vc = EmailAuthenticationViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
