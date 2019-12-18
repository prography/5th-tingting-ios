//
//  OtherTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 12/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class OtherTeamViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
 
}

extension OtherTeamViewController {
    static func initiate() -> OtherTeamViewController {
        let vc = OtherTeamViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
