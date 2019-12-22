//
//  TeamUserInfoViewController.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class TeamUserInfoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 

}

extension TeamUserInfoViewController {
    static func initiate() -> TeamUserInfoViewController {
        let vc = TeamUserInfoViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
