//
//  MatchingTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MatchingTeamViewController: BaseViewController {

    @IBOutlet weak var teamIntroView: TeamIntroView!
    @IBOutlet weak var memberListView: MemberListView!
    @IBOutlet weak var applyButton: BaseButton!
    
    private var myTeamID: Int?
    
    private let team: BehaviorRelay<Team?> = .init(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "차단", style: .plain, target: self, action: #selector(blockTeam))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getMatchingTeam()
        
        applyButton.setEnable(true)
        applyButton.isHidden = myTeamID == nil
    
        navigationController?.navigationBar.isHidden = false    
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
    }
    
    override func bind() {
        
        team.bind { [weak self] team in
            guard let self = self else { return }
            guard let team = team else { return }
            self.teamIntroView.configure(with: team)
            self.memberListView.configure(with: team.sortedUser)
            
            let isHeartSent = team.isHeartSent ?? false
            self.applyButton.isUserInteractionEnabled = !isHeartSent
            self.applyButton.setTitle(isHeartSent ? "수락 대기 중..." : "좋아요", for: .normal)
            
        }.disposed(by: disposeBag)
        
        applyButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = ApplyingMatchingTeamViewController.initiate(team: self.team.value!, myTeamID: self.myTeamID!)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.rx.deallocated.bind { [weak self] in
                self?.getMatchingTeam()
            }.disposed(by: vc.disposeBag)
            
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
     
}

extension MatchingTeamViewController {
    func getMatchingTeam() {
        startLoading()
        guard let teamID = team.value?.teamInfo.id else { return }
        NetworkManager.getMatchingTeam(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] team in
                    self?.team.accept(team)
                    self?.endLoading()
            },
                onError: { [weak self] error in
                    self?.endLoading()
                    AlertManager.showError(error)
                    Logger.error(error)
            }
        ).disposed(by: disposeBag)
    }
 
    @objc func blockTeam() {
        let alert = UIAlertController(title: "해당 팀을 차단하시겠습니까?", message: "차단된 팀은 팀 목록에 표시되지 않습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "차단", style: .destructive) { _ in
            guard let teamID = self.team.value?.teamInfo.id else { return }
            ConnectionManager.shared.blockTeam(teamID: teamID)
            self.back()
        }

        alert.addAction(cancelAction)
        alert.addAction(reportAction)
        
        present(alert, animated: true, completion: nil)
    }
}


extension MatchingTeamViewController {
    static func initiate(myTeamID: Int?, team: Team) -> MatchingTeamViewController {
        let vc = MatchingTeamViewController.withStoryboard(storyboard: .matching)
        vc.myTeamID = myTeamID
        vc.team.accept(team)
        return vc
    }
}
