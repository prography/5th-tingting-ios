//
//  TeamListViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift 

class TeamListViewController: BaseViewController {
    
    @IBOutlet weak var creatTeamButton: UIButton!
    @IBOutlet weak var peopleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    var teamList: [Team] = []
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTeamList()
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadTeamList()
    }
    override func bind() {
        
        peopleSegmentedControl.rx.selectedSegmentIndex
            .bind { [weak self] _ in
                self?.makeConfigurator()
        }.disposed(by: disposeBag)
        
        creatTeamButton.rx.tap.bind {
            let createTeamVC = CreateTeamViewController.initiate()
            self.present(createTeamVC, animated: true)
        }.disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            return cell
            
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(CellConfigurator.self)
            .bind { configurator in
                guard let joinTeamCellConfigurator = configurator as? JoinTeamCellConfigurator else {
                    assertionFailure()
                    return
                }
                
                let vc = JoinTeamViewController.initiate(team: joinTeamCellConfigurator.team)
                self.navigationController?.pushViewController(vc, animated: true)
                
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadTeamList() {
        NetworkManager.getAllTeams()
            .asObservable()
            .subscribe(
                onNext: { [weak self] teamList in
                    let blockTeamList = ConnectionManager.shared.getBlockTeamIdList()
                    let blockUserList = ConnectionManager.shared.getBlockUserIdList()
                    self?.teamList = teamList.filter {
                        
                        if blockTeamList.contains($0.teamInfo.id ?? -1) {
                            return false
                        }
                        
                        if $0.sortedUser.filter({ user in blockUserList.contains(user.id ?? -1) }).count > 0 {
                            return false
                        }
                        
                        return true
                    }
                    self?.makeConfigurator()
            },
                onError: { error in
                    Logger.error(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func makeConfigurator() {
        
        let teamList: [Team]
        
        switch peopleSegmentedControl.selectedSegmentIndex {
        case 0:
            teamList = self.teamList
        case 1:
            teamList = self.teamList.filter { $0.teamInfo.max_member_number == 2 }
        case 2:
            teamList = self.teamList.filter { $0.teamInfo.max_member_number == 3 }
        case 3:
            teamList = self.teamList.filter { $0.teamInfo.max_member_number == 4 }
        default:
            fatalError()
        }
        
        let configurators = teamList.map { JoinTeamCellConfigurator(team: $0) }
        self.items.accept(configurators)
    }
}

extension TeamListViewController {
    static func initiate() -> TeamListViewController {
        let vc = TeamListViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
