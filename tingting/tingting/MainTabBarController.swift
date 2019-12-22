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

        let firstVC  = SignInViewController.initiate()
        let secondVC = TeamListViewController.initiate()
        let thirdVC = MatchingTeamListViewController.initiate()
        let fourthVC = MyProfileViewController.initiate()

        firstVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        thirdVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        fourthVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        let tabBarList = [firstVC, secondVC, thirdVC, fourthVC]
        viewControllers = tabBarList
            .map {
                let naviVC = BaseNavigationController(rootViewController: $0)
                naviVC.navigationBar.isHidden = true
                return naviVC
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
}

