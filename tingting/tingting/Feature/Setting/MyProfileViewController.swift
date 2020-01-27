//
//  MyProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileViewController: BaseViewController {

    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var profileImageView: BaseImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    let currentUser: PublishRelay<User> = .init()
    
    let items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    var myProfile: APIModel.MyProfile?
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if let user = ConnectionManager.shared.currentUser {
            currentUser.accept(user)
        }
        
        makeConfigurator()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Check Logout
        guard ConnectionManager.shared.currentUser != nil else {
            startLoading()
            let signInVC = SignInViewController.initiate()
            signInVC.modalPresentationStyle = .fullScreen
            present(signInVC, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.endLoading()
                self.navigationController?.tabBarController?.selectedIndex = 0
            }
            return
        }
        
        loadMyProfile()
        
    }
    
    override func bind() {
        
        currentUser.bind { [weak self] user in
            ConnectionManager.shared.currentUser = user
            DispatchQueue.main.async {
                self?.profileImageView.setImage(url: user.thumbnail)
            }
            self?.nicknameLabel.text  = "\(user.name ?? "") 님"
        }.disposed(by: disposeBag)
        
        
        settingButton.rx.tap.bind { [weak self] in
            let settingVC = SettingViewController.initiate()
            self?.navigationController?.pushViewController(settingVC, animated: true)
        }.disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            
            
            if let myTeamCell = cell as? MyTeamCell {
                myTeamCell.teamInfoButton.rx.tap.bind {
                    
                    guard let teamID = myTeamCell.teamInfo.id else {
                        assertionFailure()
                        return
                    }
                    
                    let teamVC = MyTeamViewController.initiate(teamID: teamID)
                    self.navigationController?.pushViewController(teamVC, animated: true)
                    
                }.disposed(by: myTeamCell.disposeBag)
            }
            
            if let labelCell = cell as? LabelCell {
                labelCell.addButton.rx.tap.bind {
                    let createTeamVC = CreateTeamViewController.initiate()
                    
                    self.present(createTeamVC, animated: true)
                }.disposed(by: labelCell.disposeBag)
            }
            
            if let matchingTeamCell = cell as? MatchingTeamStateCell,
                let configurator = configurator as? MatchingTeamStateCellConfigurator {
                
                let matchingInfo = configurator.matchingInfo
                
                matchingTeamCell.removeButton.rx.tap
                    .bind {
                        AlertManager.show(title: "해당 기능은 아직 미 지원입니다 ㅠㅠ", subtitle: "조금만 더 기다려주세요!!")
                }.disposed(by: matchingTeamCell.disposeBag)
                
                matchingTeamCell.heartButton.rx.tap
                    .bind { [weak self] in
                        guard let self = self else { return }
                        self.startLoading()
                        
                        NetworkManager.applyMatching(matchingID: matchingInfo.id)
                            .asObservable()
                            .subscribe(
                                onNext: { [weak self] response in
                                    AlertManager.show(title: response.message)
                                    self?.loadMyProfile()
                                },
                                onError: { [weak self] error in
                                    self?.endLoading()
                                    AlertManager.showError(error)
                                }
                        ).disposed(by: self.disposeBag)
                        
                }.disposed(by: matchingTeamCell.disposeBag)
                
            }
            
            return cell
        }.disposed(by: disposeBag)
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}


extension MyProfileViewController {
    func loadMyProfile() {
        NetworkManager.getMyProfile()
            .asObservable()
            .subscribe(
                onNext: { [weak self] myProfile in
                    self?.currentUser.accept(myProfile.myInfo)
                    self?.myProfile = myProfile
                    self?.makeConfigurator()
                    self?.endLoading()
                },
                
                onError: { [weak self] error in
                    self?.endLoading()
                    AlertManager.showError(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func makeConfigurator() {
        
        let nickname = ConnectionManager.shared.currentUser?.name ?? ""
        
        let myTeamTitles = [ LabelCellConfigurator(title: "\(nickname)님의 팀", isNew: false, subtitle: nil, hasAddButton: true) ]
        
        let myTeamInfos = myProfile?.myTeamList.map { MyTeamCellConfigurator(teamInfo: $0) } ?? []
        
        let matchingTeamTitles: [CellConfigurator] = [
            LabelCellConfigurator(title: "응답 요청", isNew: false, subtitle: nil, hasAddButton: false),
            SpaceCellConfigurator(5)
        ]
        let matchingTeams = myProfile?.sentMatchings
            .map { MatchingTeamStateCellConfigurator($0) } ?? []
         
        let configurators: [CellConfigurator] =
            myTeamTitles
            + myTeamInfos
            + matchingTeamTitles
            + matchingTeams
        
        items.accept(configurators)
    }
}

extension MyProfileViewController {
    static func initiate() -> MyProfileViewController {
        let vc = MyProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}


