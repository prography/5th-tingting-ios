//
//  MemberViewController.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MemberViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension MemberViewController {
    static func initiate() -> MemberViewController {
        let vc = MemberViewController.withStoryboard(storyboard: .member)
        return vc
    }
}


