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
import M13Checkbox
import RxViewController

class CreateTeamViewController: BaseViewController {

    @IBOutlet weak var teamNameTextField: BaseTextField!
    @IBOutlet weak var memberCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var introTextView: BaseTextView!
    @IBOutlet weak var urlTextField: BaseTextField!
    
    @IBOutlet weak var tagButton: BaseButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var placeButton: UIButton!
    
    @IBOutlet weak var createTeamButton: BaseButton!
    
    @IBOutlet weak var passwordCheckbox: M13Checkbox!
    
    @IBOutlet weak var passwordTextField: BaseTextField! {
        didSet { passwordTextField.isHidden = true }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var teamType: TeamType = .create
    
    private let isValid: BehaviorRelay<Bool> = .init(value: false)
    private let tags: BehaviorRelay<[TeamTag]> = .init(value: [])
    
    lazy var placeDropDown: DropDown = {
        let dropdown = DropDown()
        dropdown.bottomOffset = CGPoint(x: -20, y: placeButton.bounds.height + 13)
        dropdown.anchorView = placeButton
        return dropdown
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropDown()
        memberCountSegmentedControl.setSegmentStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch teamType {
        case .create:
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.tintColor = .primary
            createTeamButton.setTitle("팀만들기", for: .normal)
        case .edit(let team):
            
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.tintColor = .primary
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "팀 나가기", style: .done, target: self, action: #selector(exitTeam))
            
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
                let filteredText = self?.teamNameTextField.text?.filter { $0 != " " }
                if self?.teamNameTextField.text != filteredText {
                    self?.teamNameTextField.text = filteredText
                }
                self?.checkValidation()
        }.disposed(by: disposeBag)
        
        introTextView.rx.text.bind { [weak self] _ in
            self?.checkValidation()
        }.disposed(by: disposeBag)
         
        // Tag
        tagButton.rx.tap.bind { [weak self] in
            let teamTagVC = TeamTagViewController.initiate()
            teamTagVC.selectedTag = self?.tags.value ?? []
            teamTagVC.modalTransitionStyle = .crossDissolve
            teamTagVC.modalPresentationStyle = .overFullScreen
            self?.present(teamTagVC, animated: true)
            
            teamTagVC.rx.viewDidDisappear.bind { [weak self, weak teamTagVC] _ in
                guard let tags = teamTagVC?.selectedTag, teamTagVC?.didButtonPressed == true else { return }
                self?.tags.accept(tags)
            }.disposed(by: teamTagVC.disposeBag)
            
        }.disposed(by: disposeBag)
        
        tagCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        tagCollectionView.allowsSelection = false
        tags.bind(to: tagCollectionView.rx.items(cellIdentifier: "cell")) { row, teamTag, cell in
            guard let tagCell = cell as? TagCell else { return }
            tagCell.tagLabel.text = "#" + teamTag.name
        }.disposed(by: disposeBag)
        
        urlTextField.rx
            .controlEvent([.editingChanged])
            .bind(onNext: checkValidation)
            .disposed(by: disposeBag)
        
        // TODO: Add Tag logic
        isValid.bind(onNext: createTeamButton.setEnable)
            .disposed(by: disposeBag)
        
        createTeamButton.rx.tap.bind { [weak self] in
            self?.createTeam()
        }.disposed(by: disposeBag)
        
        passwordCheckbox.stateDriver.driveNext { [weak self] state in
            self?.checkValidation()
            UIView.animate(withDuration: 0.3) {
                switch state {
                case .checked:
                    self?.passwordTextField.isHidden = false
                    
                case .mixed, .unchecked:
                    self?.passwordTextField.text = ""
                    self?.passwordTextField.isHidden = true
                    
                }
            }
        }.disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent([.editingChanged])
            .compactMap { [weak self] in self?.passwordTextField.text }
            .filter { $0.count > 4 }
            .map { $0[0..<4] }
            .bind { [weak self] text in
                self?.passwordTextField.text = text
                self?.checkValidation() }
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll.bind { [weak self] in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        scrollView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
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
         
        
//        guard let intro = introTextView.text, (1...100).contains(intro.count) else {
//            isValid.accept(false)
//            return
//        }
        
//        guard let url = urlTextField.text, !url.isEmpty else {
//            isValid.accept(false)
//            return
//        }
        
        guard let place = placeButton.titleLabel?.text, Constants.placeList.contains(place) else {
            isValid.accept(false)
            return
        }
        
        if passwordCheckbox.checkState == .checked {
            guard passwordTextField.text?.count == 4 else {
                isValid.accept(false)
                return
            }
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
        
        let password = passwordTextField.text?.count == 4 ? passwordTextField.text : nil
        let tagIds = tags.value.map { $0.id }
        let max_member_number = memberCountSegmentedControl.selectedSegmentIndex + 2
 
        startLoading(backgroundColor: .clear)
        
        switch teamType {
        case .create:
            
            
            let team = TeamInfo(name: name,
                                chat_address: chat_address,
                                owner_id: currentUser.id,
                                intro: intro,
                                gender: gender,
                                password: password,
                                max_member_number: max_member_number,
                                is_matched: nil,
                                accepter_number: nil,
                                place: place,
                                tagIds: tagIds)

            NetworkManager.checkDuplicate(teamName: name).asObservable()
                .subscribe(
                    onNext: { [weak self] response in
                        guard let self = self else { return }
                        
                        
                        NetworkManager.createTeam(team)
                            .asObservable()
                            .subscribe(
                                onNext: { team in
                                    self.navigationController?.popViewController(animated: true)
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
                                password: password,
                                max_member_number: max_member_number,
                                is_matched: nil,
                                accepter_number: nil,
                                place: place,
                                tagIds: nil)
            
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
 
