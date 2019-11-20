//
//  MainViewController.swift
//  tingting
//
//  Created by 김선우 on 11/6/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // let vc = SignInViewController.withStoryboard(storyboard: .user)
        
        let vc = TeamListViewController.withStoryboard(storyboard: .team)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }


}

