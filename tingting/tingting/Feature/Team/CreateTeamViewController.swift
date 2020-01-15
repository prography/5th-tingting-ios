//
//  CreateTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WSTagsField

class CreateTeamViewController: BaseViewController {

    @IBOutlet weak var teamNameTextField: BaseTextField!
    @IBOutlet weak var memberCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var introTextView: BaseTextView!
    @IBOutlet weak var urlTextField: BaseTextField!
    @IBOutlet weak var tagsView: UIView!
    
    @IBOutlet weak var createTeamButton: BaseButton!
    
    private let isValid: BehaviorRelay<Bool> = .init(value: false)
    
    fileprivate let tagsField = WSTagsField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTagsField()
    }
    
    override func bind() {
        
        teamNameTextField.rx
            .controlEvent([.editingChanged])
            .bind(onNext: checkValidation)
            .disposed(by: disposeBag)
        
        introTextView.rx.text.bind { _ in
            self.checkValidation()
        }.disposed(by: disposeBag)
         
        urlTextField.rx
            .controlEvent([.editingChanged])
            .bind(onNext: checkValidation)
            .disposed(by: disposeBag)
        
        // TODO: Add Tag logic
        
        isValid.bind(onNext: createTeamButton.setEnable)
            .disposed(by: disposeBag)
        
        createTeamButton.rx.tap.bind {
            self.createTeam()
        }.disposed(by: disposeBag)
    }
    
    func setTagsField() {
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)

        //tagsField.translatesAutoresizingMaskIntoConstraints = false
        //tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true

        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10

        
        //tagsField.numberOfLines = 3
        //tagsField.maxHeight = 100.0

        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding

        tagsField.placeholder = "태그를 입력하세요.."
        tagsField.placeholderColor = .lightGray
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = #colorLiteral(red: 0.9719446301, green: 0.9719673991, blue: 0.9719551206, alpha: 1)
        tagsField.tintColor = .primary
        tagsField.returnKeyType = .continue
        tagsField.delimiter = ""
        
        

        tagsField.textDelegate = self

        textFieldEvents()
    }
}
 
extension CreateTeamViewController {
    
    private func checkValidation() {
        guard let teamName = teamNameTextField.text, (1...8).contains(teamName.count) else {
            isValid.accept(false)
            return
        }
        
        guard let intro = introTextView.text, (1...100).contains(intro.count) else {
            isValid.accept(false)
            return
        }
        
        guard let url = urlTextField.text, !url.isEmpty else {
            isValid.accept(false)
            return
        }
        
        // TODO: Add tag logic
        
        isValid.accept(true)
          
    }
    
    private func createTeam() {
        
        guard
            let currentUser = ConnectionManager.shared.currentUser,
            let name = teamNameTextField.text,
            let chat_address = urlTextField.text,
            let intro = introTextView.text,
            let gender = currentUser.gender
            else {
                assertionFailure()
                return
        }
        
        // TODO: Add password
        // let password: String? = nil

        let max_member_number = memberCountSegmentedControl.selectedSegmentIndex + 2
        let team = TeamInfo(name: name,
                            chat_address: chat_address,
                            owner_id: nil,
                            intro: intro,
                            gender: gender,
                            password: nil,
                            max_member_number: max_member_number)
        startLoading(backgroundColor: .clear)
        NetworkManager.createTeam(team)
            .asObservable()
            .subscribe(
            onNext: { team in
                self.dismiss(animated: true)
        },
            onError: { error in
                Logger.error(error)
                AlertManager.showError(error)
                self.endLoading()
            }).disposed(by: disposeBag)
    }

    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }

        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }

}

extension CreateTeamViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
//            anotherField.becomeFirstResponder()
        }
        return true
    }

}

extension CreateTeamViewController {
    static func initiate() -> CreateTeamViewController {
        let vc = CreateTeamViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
