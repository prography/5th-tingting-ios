//
//  EditProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var imageView: BaseImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var editButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker(birthTextField)
    }
    
    override func bind() {
         
        editButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                guard var user = ConnectionManager.shared.currentUser else { assertionFailure(); return }
                user.height = Int(self.heightTextField.text ?? "0")
                user.birth = self.birthTextField.text
                self.startLoading(backgroundColor: .clear)
                NetworkManager.editMyProfile(to: user).asObservable()
                    .subscribe(
                        onNext: { [weak self] response in
                            ConnectionManager.shared.currentUser = user
                            AlertManager.show(title: response.message)
                            self?.endLoading()
                            self?.navigationController?.popToRootViewController(animated: true)
                    },
                        onError: { [weak self] error in
                            AlertManager.showError(error)
                            self?.endLoading()
                    }
                ).disposed(by: self.disposeBag)
                
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = ConnectionManager.shared.currentUser else { assertionFailure(); return }
        imageView.setImage(url: user.thumbnail)
        nicknameTextField.text = user.name ?? ""
        genderTextField.text = user.gender?.korean ?? ""
        birthTextField.text = user.birth ?? ""
        schoolTextField.text = user.schoolName ?? ""
        heightTextField.text = "\(user.height ?? -1)"
        
        nicknameTextField.isEnabled = false
        genderTextField.isEnabled = false
        schoolTextField.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


extension EditProfileViewController {
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
    }
    
}

extension EditProfileViewController {
    static func initiate() -> EditProfileViewController {
        let vc = EditProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}

