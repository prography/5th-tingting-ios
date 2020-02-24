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
import DropDown
import WSTagsField

class CreateTeamViewController: BaseViewController {

    @IBOutlet weak var teamNameTextField: BaseTextField!
    @IBOutlet weak var memberCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var introTextView: BaseTextView!
    @IBOutlet weak var urlTextField: BaseTextField!
    @IBOutlet weak var tagsView: UIView!
    
    @IBOutlet weak var placeButton: UIButton!
    
    @IBOutlet weak var createTeamButton: BaseButton!
    
    private var teamType: TeamType = .create
    
    private let isValid: BehaviorRelay<Bool> = .init(value: false)
    
    fileprivate let tagsField = WSTagsField()
    
    lazy var placeDropDown: DropDown = {
        let dropdown = DropDown()
        dropdown.bottomOffset = CGPoint(x: -20, y: placeButton.bounds.height + 13)
        dropdown.anchorView = placeButton
        return dropdown
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setTagsField()
        setDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch teamType {
        case .create:
            createTeamButton.setTitle("팀만들기", for: .normal)
        case .edit(let team):
            
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.tintColor = .primary
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "팀 나가기", style: .done, target: self, action: #selector(exitTeam))
            teamNameTextField.text = team.teamInfo.name
            teamNameTextField.isEnabled = false
            memberCountSegmentedControl.isEnabled = false
            memberCountSegmentedControl.selectedSegmentIndex = (team.teamInfo.max_member_number ?? 0) + 2
            introTextView.text = team.teamInfo.intro
            placeButton.setTitle(team.teamInfo.place, for: .normal)
            urlTextField.text = team.teamInfo.chat_address
            createTeamButton.setTitle("수정하기", for: .normal)
            
            let isOwnerMe = team.teamInfo.owner_id == ConnectionManager.shared.currentUser?.id
            
            if !isOwnerMe {
                introTextView.isEditable = false
                urlTextField.isEnabled = false
                createTeamButton.isHidden = true
            }
            
        }
        
        
    }
    
    override func bind() {
        
        placeButton.rx.tap
            .bind { [weak self] in
                self?.placeDropDown.show()
        }.disposed(by: disposeBag)
        
        placeDropDown.selectionAction = { [weak self] index, item in
            self?.placeButton.setTitle(item, for: .normal)
            self?.checkValidation()
        }
        
        teamNameTextField.rx
            .controlEvent([.editingChanged])
            .bind { [weak self] in
                self?.teamNameTextField.text = self?.teamNameTextField.text?.filter { $0 != " " }
                self?.checkValidation()
        }.disposed(by: disposeBag)
        
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
        guard let teamName = teamNameTextField.text, !teamName.isEmpty else {
            isValid.accept(false)
            return
        }
          
        guard teamName.count <= 8 else {
            isValid.accept(false)
            teamNameTextField.text = teamName[0..<8]
            checkValidation()
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
        
        guard let place = placeButton.titleLabel?.text, Constants.placeList.contains(place) else {
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
            let gender = currentUser.gender,
            let place = placeButton.titleLabel?.text
            else
        {
                assertionFailure()
                return
        }
        
        // TODO: Add password
        // TODO: Add place
        // let password: String? = nil

        let max_member_number = memberCountSegmentedControl.selectedSegmentIndex + 2
 
        startLoading(backgroundColor: .clear)
        
        switch teamType {
        case .create:
            
            let team = TeamInfo(name: name,
                                chat_address: chat_address,
                                owner_id: currentUser.id,
                                intro: intro,
                                gender: gender,
                                password: nil,
                                max_member_number: max_member_number,
                                is_matched: nil,
                                accepter_number: nil,
                                place: place)

            NetworkManager.checkDuplicate(teamName: name).asObservable()
                .subscribe(
                    onNext: { [weak self] response in
                        guard let self = self else { return }
                        
                        
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
                            }
                        ).disposed(by: self.disposeBag)
                        
                    
                        
                    },
                    onError: { error in
                        Logger.error(error)
                        AlertManager.showError(error)
                        self.endLoading()
                }
            ).disposed(by: disposeBag)
            
        case .edit(let oldTeam):
            
            let team = TeamInfo(name: name,
                                chat_address: chat_address,
                                owner_id: oldTeam.teamInfo.owner_id,
                                intro: intro,
                                gender: gender,
                                password: nil,
                                max_member_number: max_member_number,
                                is_matched: nil,
                                accepter_number: nil,
                                place: place)
            
            NetworkManager.editTeamInfo(id: oldTeam.teamInfo.id!,
                                        teamInfo: team)
                .asObservable()
                .subscribe(
                    onNext: { [weak self] team in
                        AlertManager.show(title: "팀 정보가 수정되었습니다.")
                        self?.endLoading()
                        self?.back()
                        
                    },
                    onError: { [weak self] error in
                        AlertManager.showError(error)
                        self?.endLoading()
                    }
            ).disposed(by: disposeBag)
        }
        

         
    }

    
    func setDropDown() {
         
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //        appearance.textFont = UIFont(name: "Georgia", size: 14)
        
        placeDropDown.dataSource = Constants.placeList
        placeDropDown.reloadAllComponents()
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
    
    @objc func exitTeam() {
        
        let alert = UIAlertController(title: "정말 팀을 나가시겠습니까?", message: "팀을 나가면 되돌릴 수 없습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let exitAction = UIAlertAction(title: "팀나기기", style: .default) { [weak self] action in
            guard let self = self else { return }
            switch self.teamType {
            case .create:
                assertionFailure()
            case .edit(let team):
                self.startLoading(backgroundColor: .clear)
                guard let teamID = team.teamInfo.id else { assertionFailure(); return }
                NetworkManager.leaveTeam(id: teamID)
                    .asObservable()
                    .subscribe(
                        onNext: { [weak self] response in
                            AlertManager.show(title: response.message)
                            self?.endLoading()
                            self?.navigationController?.navigationBar.isHidden = true
                            self?.navigationController?.popToRootViewController(animated: true)
                        },
                        onError: { [weak self] error in
                            AlertManager.showError(error)
                            self?.endLoading()
                        }
                ).disposed(by: self.disposeBag)
                
            }
        }
        
        
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
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
    enum TeamType {
        case create
        case edit(team: Team)
    }
    
    static func initiate(teamType: TeamType = .create) -> CreateTeamViewController {
        let vc = CreateTeamViewController.withStoryboard(storyboard: .team)
        vc.teamType = teamType
        return vc
    }
}
