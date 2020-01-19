//
//  MyProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileViewController: BaseViewController {

    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var profileImageView: BaseImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    let currentUser: BehaviorRelay<User> = .init(value: ConnectionManager.shared.currentUser!)
    let items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let configurators: [CellConfigurator] = [
            LabelCellConfigurator(title: "룰루랄라님의 팀", isNew: false, subtitle: nil, hasAddButton: true),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(), 
            
            
            LabelCellConfigurator(title: "응답 요청", isNew: false, subtitle: nil, hasAddButton: false),
            SpaceCellConfigurator(5),
            MatchingTeamStateCellConfigurator(),
            MatchingTeamStateCellConfigurator()
        ]
        
        items.accept(configurators)
        
    }
    
    override func bind() {
        
        currentUser.bind { [weak self] user in
            ConnectionManager.shared.currentUser = user
            self?.profileImageView.setImage(url: user.thumbnail)
            self?.nicknameLabel.text = "\(user.name ?? "") 님"
        }.disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            
            
            if let myTeamCell = cell as? MyTeamCell {
                myTeamCell.teamInfoButton.rx.tap.bind {
                    let teamVC = MyTeamViewController.initiate()
                    self.navigationController?.pushViewController(teamVC, animated: true)
                }.disposed(by: myTeamCell.disposeBag)
            }
            
            if let labelCell = cell as? LabelCell {
                labelCell.addButton.rx.tap.bind {
                    let createTeamVC = CreateTeamViewController.initiate()
                    self.present(createTeamVC, animated: true)
                }.disposed(by: labelCell.disposeBag)
            }
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.getMyProfile()
            .asObservable()
            .subscribe(
                onNext: { [weak self] myProfile in
                    self?.currentUser.accept(myProfile.myInfo)
                },
                
                onError: { error in
                    AlertManager.showError(error)
            }
        ).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}

extension MyProfileViewController {
    static func initiate() -> MyProfileViewController {
        let vc = MyProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}


