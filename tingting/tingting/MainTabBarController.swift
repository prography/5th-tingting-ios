//
//  MainTabBarController.swift
//  tingting
//
//  Created by 김선우 on 11/6/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit 

class MainTabBarController: BaseTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let firstVC = TeamListViewController.initiate()
        let secondVC = MatchingTeamListViewController.initiate()
        let thirdVC = MyProfileViewController.initiate()
 
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        secondVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        thirdVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let tabBarList = [firstVC, secondVC, thirdVC]
        viewControllers = tabBarList
            .map {
                let naviVC = BaseNavigationController(rootViewController: $0)
                naviVC.navigationBar.isHidden = true
                return naviVC
        }
        
        DispatchQueue.main.async {
            let signInVC  = SignInViewController.initiate()
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: false)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
}

