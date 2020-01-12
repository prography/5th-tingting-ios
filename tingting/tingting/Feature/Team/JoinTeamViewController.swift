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
    
    
    var team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamIntroView.configure(with: team)
        memberListView.configure(with: team.members)

        // Do any additional setup after loading the view.
    }
}

extension JoinTeamViewController {
    static func initiate(team: Team) -> JoinTeamViewController {
        let vc = JoinTeamViewController.withStoryboard(storyboard: .team)
        vc.team = team
        return vc
    }
}

