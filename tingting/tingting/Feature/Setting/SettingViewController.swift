//
//  SettingViewController.swift
//  tingting
//
//  Created by 김선우 on 1/20/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//
  
import UIKit
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController {
    
    @IBOutlet weak var logoutButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
    }
    
    override func bind() {
        logoutButton.rx.tap
            .bind { [weak self] in
                ConnectionManager.shared.logout()
                
                self?.navigationController?.popToRootViewController(animated: true)
                
                
        }.disposed(by: disposeBag)
    }
    
}

extension SettingViewController {
    static func initiate() -> SettingViewController {
        let vc = SettingViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}

