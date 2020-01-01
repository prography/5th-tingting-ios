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
    
    var items: [CellConfigurator] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        items = [
            LabelCellConfigurator(title: "룰루랄라님의 팀", isNew: false, subtitle: nil, hasAddButton: true),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),
            
            LabelCellConfigurator(title: "응답 요청", isNew: false, subtitle: nil, hasAddButton: false),
            MatchingTeamStateCellConfigurator(),
            MatchingTeamStateCellConfigurator()
        ]
        
    }
    
    override func bind() {
        Observable.just(items).bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
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


