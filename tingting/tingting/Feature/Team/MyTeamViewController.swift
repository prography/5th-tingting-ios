//
//  MyTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 1/5/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyTeamViewController: BaseViewController {
    
    @IBOutlet weak var teamIntroView: TeamIntroView!
    @IBOutlet weak var memberListView: MemberListView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    private var teamID: Int!
    private var team: Team?
    
    
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyTeamInfo()
        startLoading()
 
        
        let configurators: [CellConfigurator] = [
            LabelCellConfigurator(title: "매칭 현황", isNew: true, subtitle: "매칭 진행 중", hasAddButton: false),
            MyMatchingTeamCellConfigurator(),
            MyMatchingTeamCellConfigurator(),
            MyMatchingTeamCellConfigurator()
        ]
        
        items.accept(configurators)
    }
    
    override func bind() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
             
            return cell
        }.disposed(by: disposeBag)
    }
     

}

extension MyTeamViewController {
    
    func getMyTeamInfo() {
        startLoading(backgroundColor: .clear)
        NetworkManager.getTeamInfo(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] team in
                    guard let self = self else { return }
                    self.team = team
                    self.teamIntroView.configure(with: team)
                    self.memberListView.configure(with: team.teamMembers)
                    self.endLoading()
                },
                onError: { [weak self] error in
                    self?.endLoading()
                    AlertManager.showError(error)
                }
        ).disposed(by: disposeBag)
    }
    
}

extension MyTeamViewController {
    static func initiate(teamID: Int) -> MyTeamViewController {
        let vc = MyTeamViewController.withStoryboard(storyboard: .team)
        vc.teamID = teamID
        return vc
    }
}

