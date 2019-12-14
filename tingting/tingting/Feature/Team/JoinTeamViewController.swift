//
//  JoinTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class JoinTeamViewController: BaseViewController {

    @IBOutlet private weak var introView: TeamIntroView!
    @IBOutlet private weak var memberListView: MemberListView!
    @IBOutlet private weak var teamListView: TeamListView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension JoinTeamViewController {
    static func initiate() -> JoinTeamViewController {
        let vc = JoinTeamViewController.withStoryboard(storyboard: .team)
        return vc
    }
}
