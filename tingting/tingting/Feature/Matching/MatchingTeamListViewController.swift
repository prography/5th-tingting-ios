//
//  MatchingTeamListViewController.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa 
import RxDataSources

class MatchingTeamListViewController: BaseViewController {

    @IBOutlet private weak var introView: TeamIntroView!
    @IBOutlet private weak var memberListView: MemberListView!
    @IBOutlet private weak var teamListView: TeamListView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        teamListView.teamDriver
            .driveNext { team in
                Logger.info(team)
                let matchingTeamVC = MatchingTeamViewController.initiate()
                self.present(matchingTeamVC, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension MatchingTeamListViewController {
    static func initiate() -> MatchingTeamListViewController {
        let vc = MatchingTeamListViewController.withStoryboard(storyboard: .matching)
        return vc
    }
}
