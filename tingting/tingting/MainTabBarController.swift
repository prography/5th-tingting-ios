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
        let thirdVC  = MyProfileViewController.initiate()

        firstVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        thirdVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .more, tag: 2)

        let tabBarList = [firstVC, secondVC, thirdVC]
        viewControllers = tabBarList.map { BaseNavigationController(rootViewController: $0) }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
}

