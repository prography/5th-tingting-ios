//
//  SignUpViewController.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
     
}

extension SignUpViewController {
    static func initiate() -> SignUpViewController {
        let vc = SignUpViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
