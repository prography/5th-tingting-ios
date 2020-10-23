//
//  JoinTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/31/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JoinTeamViewController: BaseViewController {
    
    @IBOutlet weak var teamIntroView: TeamIntroView!
    @IBOutlet weak var memberListView: MemberListView!
    @IBOutlet weak var joinButton: BaseButton!
    
    
    var team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "차단", style: .plain, target: self, action: #selector(blockTeam))
        memberListView.configure(with: team.sortedUser)
        joinButton.setEnable(true)
        
    }
    override func bind() {
        joinButton.rx.tap
            .bind { [weak self] in
                self?.joinTeam()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading(backgroundColor: .clear)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary 
        guard let teamID = team.teamInfo.id else {
            assertionFailure()
            return
        }
        NetworkManager.getTeamInfo(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] team in
                    guard let self = self else { return }
                    
                    self.team = team
                    self.team.teamInfo.id = teamID
                    self.teamIntroView.configure(with: team)
                    self.memberListView.configure(with: team.sortedUser)
                    self.endLoading()
                    
                },
                onError: { [weak self] error in
                    Logger.error(error)
                    self?.endLoading()
                }
        ).disposed(by: disposeBag)
        
    }

}

extension JoinTeamViewController {
    func joinTeam() {

        guard let teamID = team.teamInfo.id else {
            assertionFailure()
            return
        }
        
        startLoading(backgroundColor: .clear)
        
        NetworkManager.joinTeam(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { response in
                    AlertManager.show(title: response.message)
                    self.back()
            },
                onError: { [weak self] error in
                    Logger.error(error)
                    AlertManager.showError(error)
                    self?.endLoading()
                }
                
        ).disposed(by: disposeBag)
    }
    
    @objc func blockTeam() {
        let alert = UIAlertController(title: "해당 팀을 차단하시겠습니까?", message: "차단된 팀은 팀 목록에 표시되지 않습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "차단", style: .destructive) { _ in
            guard let teamID = self.team.teamInfo.id else { return }
            ConnectionManager.shared.blockTeam(teamID: teamID)
            self.back()
        }

        alert.addAction(cancelAction)
        alert.addAction(reportAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


extension JoinTeamViewController {
    static func initiate(team: Team) -> JoinTeamViewController {
        let vc = JoinTeamViewController.withStoryboard(storyboard: .team)
        vc.team = team
        return vc
    }
}

