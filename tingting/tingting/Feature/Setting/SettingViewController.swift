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
    @IBOutlet weak var clearBlockTeamButton: BaseButton!
    
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
        
        clearBlockTeamButton.rx.tap.bind { [weak self] in
            
            let alert = UIAlertController(title: "차단된 팀을 초기화 하시겠습니까?", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let reportAction = UIAlertAction(title: "초기화", style: .destructive) { _ in
                ConnectionManager.shared.clearBlockTeam()
                AlertManager.show(title: "초기화 되었습니다.")
            }

            alert.addAction(cancelAction)
            alert.addAction(reportAction)
            
            self?.present(alert, animated: true, completion: nil)

            
            
        }.disposed(by: disposeBag)
        
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

