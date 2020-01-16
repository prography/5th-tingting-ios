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
        
        teamIntroView.configure(with: team)
        memberListView.configure(with: team.members)
 
    }
    override func bind() {
        joinButton.rx.tap
            .bind(onNext: joinTeam)
            .disposed(by: disposeBag)
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
                    self?.endLoading()
                }
                
        ).disposed(by: disposeBag)
    }
}


extension JoinTeamViewController {
    static func initiate(team: Team) -> JoinTeamViewController {
        let vc = JoinTeamViewController.withStoryboard(storyboard: .team)
        vc.team = team
        return vc
    }
}

