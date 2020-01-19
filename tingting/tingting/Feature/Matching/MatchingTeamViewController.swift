//
//  MatchingTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MatchingTeamViewController: BaseViewController {

    @IBOutlet weak var teamIntroView: TeamIntroView!
    @IBOutlet weak var memberListView: MemberListView!
    @IBOutlet weak var applyButton: BaseButton!
    
    private var team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        guard let teamID = team.teamInfo.id else { return }
        NetworkManager.getMatchingTeam(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] team in
                    self?.team = team
                    self?.endLoading()
            },
                onError: { [weak self] error in
                    self?.endLoading()
                    AlertManager.showError(error)
                    Logger.error(error)
            }
        ).disposed(by: disposeBag)
        
        
        teamIntroView.configure(with: team)
        memberListView.configure(with: team.teamMembers)
    }
    
 
}

extension MatchingTeamViewController {
    static func initiate(to team: Team) -> MatchingTeamViewController {
        let vc = MatchingTeamViewController.withStoryboard(storyboard: .matching)
        vc.team = team
        return vc
    }
}
