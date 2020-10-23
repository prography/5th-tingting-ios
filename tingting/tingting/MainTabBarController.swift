//
//  MainTabBarController.swift
//  tingting
//
//  Created by 김선우 on 11/6/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabBarController: BaseTabBarController, UITabBarControllerDelegate {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let firstVC = MatchingTeamListViewController.initiate()
        let secondVC = TeamListViewController.initiate()
        let thirdVC = MyProfileViewController.initiate()

        
        firstVC.tabBarItem = UITabBarItem(title: "매칭",
                                          image: UIImage(named: "cupid"),
                                          selectedImage: UIImage(named: "cupid1"))
        
        secondVC.tabBarItem = UITabBarItem(title: "팀 찾기",
                                           image: UIImage(named: "support"),
                                           selectedImage: UIImage(named: "support1"))
        
        thirdVC.tabBarItem = UITabBarItem(title: "프로필",
                                          image: UIImage(named: "user1"),
                                          selectedImage: UIImage(named: "user2"))
        
        let tabBarList = [firstVC, secondVC, thirdVC]
        tabBarList.enumerated().forEach { $0.element.tabBarItem.tag = $0.offset }
        viewControllers = tabBarList
            .map {
                let naviVC = BaseNavigationController(rootViewController: $0)
                naviVC.navigationBar.isHidden = true
                return naviVC
            }
        
        setLogin()
        // TODO: Remove
        // ConnectionManager.shared.currentUser = MockTeam.getMockResponse().members.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = .primary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // AlertManager.show(title: "목데이터에유~")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
}
extension MainTabBarController {
    
    func setLogin() {
        guard ConnectionManager.shared.loadToken() != nil else {
            presentSignInVC()
            return
        }
        
        NetworkManager.getMyProfile()
            .asObservable()
            .subscribe(
                onNext: { profile in
                    ConnectionManager.shared.currentUser = profile.myInfo
                    AlertManager.show(title: profile.myInfo.name! + "님 오늘 매칭이 궁금해요~ ><")
            },
                onError: { error in
                    self.presentSignInVC()
                    Logger.error(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func presentSignInVC() {
        DispatchQueue.main.async {
            let signInVC  = SignInViewController.initiate()
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: false)
        }
    }
}

