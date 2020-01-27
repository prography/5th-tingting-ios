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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getMatchingTeam()
        applyButton.isHidden = myTeamID == nil 
    }
    
    override func bind() {
        
        team.bind { [weak self] team in
            guard let self = self else { return }
            guard let team = team else { return }
            self.teamIntroView.configure(with: team)
            self.memberListView.configure(with: team.teamMembers)
            
            let isHeartSent = team.isHeartSent ?? false
            self.applyButton.isUserInteractionEnabled = !isHeartSent
            self.applyButton.setTitle(isHeartSent ? "수락 대기 중..." : "좋아요", for: .normal)
            
        }.disposed(by: disposeBag)
        
        applyButton.rx.tap.bind { [weak self] in
            self?.showMessageAlert()
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
    
    func showMessageAlert() {
        AlertManager.show(title: "이거 대신 메세지 입력하는 거 나와야 함.")
        applyMatching()
        
    }
    
    func applyMatching() {
        
        startLoading(backgroundColor: .clear)
        var request = APIModel.ApplyMatching.Request()
        
        request.receiveTeamId = team.value?.teamInfo.id
        request.sendTeamId = myTeamID
        request.message = "안녕하세요. 이것은 테스트 메세지이지만 그래도 받아주실거죠?"
        
        NetworkManager.applyFirstMatching(request: request)
            .asObservable()
            .subscribe(
                onNext: { [weak self] response in
                    AlertManager.show(title: response.message)
                    self?.getMatchingTeam()
            },
                onError: { [weak self] error in
                    AlertManager.showError(error)
                    self?.endLoading()
            }
        ).disposed(by: disposeBag)
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
