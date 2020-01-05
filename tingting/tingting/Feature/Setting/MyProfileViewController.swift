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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    
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
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            
            
            if let myTeamCell = cell as? MyTeamCell {
                myTeamCell.teamInfoButton.rx.tap.bind {
                    let teamVC = MyTeamViewController.initiate()
                    self.navigationController?.pushViewController(teamVC, animated: true)
                }.disposed(by: myTeamCell.disposeBag)
            }
            
            
            return cell
        }.disposed(by: disposeBag)
    }
    
}

extension MyProfileViewController {
    static func initiate() -> MyProfileViewController {
        let vc = MyProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}


