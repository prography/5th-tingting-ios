//
//  MatchingTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MatchingTeamViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
 
}

extension MatchingTeamViewController {
    static func initiate() -> MatchingTeamViewController {
        let vc = MatchingTeamViewController.withStoryboard(storyboard: .matching)
        
        return vc
    }
}
