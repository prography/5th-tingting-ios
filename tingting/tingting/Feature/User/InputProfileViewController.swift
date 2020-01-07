//
//  InputProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputProfileViewController: BaseViewController {

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var checkNicknameMarkImageView: UIImageView!
    @IBOutlet weak var duplicationCheckButton: BaseButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    private var isNewNickname: BehaviorRelay<Bool> = .init(value: false)
    private var isSchoolValid: BehaviorRelay<Bool> = .init(value: false)
    
    private var isValid: BehaviorRelay<Bool> = .init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker(birthTextField)
    }
    
    override func bind() {
        isNewNickname.bind { isNewNickname in
            self.checkValidation()
            self.checkNicknameMarkImageView.isHidden = !isNewNickname
            self.duplicationCheckButton.isHidden = isNewNickname
        }.disposed(by: disposeBag)
        
        nicknameTextField.rx
            .controlEvent([.editingChanged])
            .compactMap { _ in false }
            .bind(to: isNewNickname)
            .disposed(by: disposeBag)
        
        duplicationCheckButton.rx.tap
            .bind { self.checkDuplicate() }
            .disposed(by: disposeBag)
        
        heightTextField.rx
            .controlEvent([.editingChanged])
            .bind { self.checkValidation() }
            .disposed(by: disposeBag)
        
        birthTextField.rx
            .controlEvent([.editingChanged])
            .bind { self.checkValidation() }
            .disposed(by: disposeBag)
 
        isValid
            .bind(onNext: nextButton.setEnable)
            .disposed(by: disposeBag)

        nextButton.rx.tap.bind {
            ConnectionManager.shared.signUpRequest.name = self.nicknameTextField.text
            ConnectionManager.shared.signUpRequest.birth = self.birthTextField.text
            ConnectionManager.shared.signUpRequest.gender = self.genderSegmentedControl.selectedSegmentIndex
            ConnectionManager.shared.signUpRequest.height = Int(self.heightTextField.text ?? "0")
            
            let emailVC = EmailAuthenticationViewController.initiate()
            self.navigationController?.pushViewController(emailVC, animated: true)
        }.disposed(by: disposeBag)
    }
     
    func checkDuplicate() {
        
        guard let nickname =  nicknameTextField.text, !nickname.isEmpty else {
            AlertManager.showError("닉네임을 입력해주세요")
            return
        }
         
        startLoading(backgroundColor: .clear)
        
        NetworkManager.checkDuplicate(name: nickname)
            .asObservable()
            .subscribe(
                onNext: { response in
                    AlertManager.show(title: response.message)
                    self.isNewNickname.accept(true)
            },
                onError: { error in
                    self.isNewNickname.accept(false)
                    AlertManager.showError(error)
            },
                onDisposed:  {
                    self.endLoading()
            }
        ).disposed(by: disposeBag)
    }
    
    @IBAction func setDatePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }

    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
        checkValidation()
    }
    
    func checkValidation() {
        
        guard let birth = birthTextField.text, birth.count >= 8 else {
            isValid.accept(false)
            return
        }
        
        guard let height = heightTextField.text, height.count >= 3 else {
            isValid.accept(false)
            return
        }
        
        
        guard isNewNickname.value else {
            isValid.accept(false)
            return
        }

        isValid.accept(true)
    }
}

extension InputProfileViewController {
    static func initiate() -> InputProfileViewController {
        let vc = InputProfileViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
