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
    
    private let isValid: BehaviorRelay<Bool> = .init(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func bind() {
        
        emailTextField.rx
            .controlEvent([.editingChanged])
            .bind { [weak self] in
                let email = self?.emailTextField.text
                self?.emailTextField.text = email?.filter { $0 != " " } ?? ""
                let isValid = Validator.check(email: self?.emailTextField.text)
                self?.sendButton.setEnable(isValid)
                self?.isValid.accept(false)
                
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
         
        guard let nickname = ConnectionManager.shared.signUpRequest.name else {
            assertionFailure("Nickname must exist!!")
            return }
        
        let request = APIModel.School.Request(
            name: nickname,
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
                    ConnectionManager.shared.signUpRequest.authenticated_address = email
                    AlertManager.show(title: response.message)
                    let vc = InputPhotoViewController.initiate()
                    self.navigationController?.pushViewController(vc, animated: true)
            },
                onError: { error in
                    AlertManager.showError(error)
            }
        ).disposed(by: disposeBag)
    }
    
}

extension EmailAuthenticationViewController {
    static func initiate() -> EmailAuthenticationViewController {
        
        let vc = EmailAuthenticationViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
