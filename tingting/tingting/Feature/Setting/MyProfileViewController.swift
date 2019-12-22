//
//  MyProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyProfileViewController {
    static func initiate() -> MyProfileViewController {
        let vc = MyProfileViewController.withStoryboard(storyboard: .setting)
        
        return vc
    }
}


