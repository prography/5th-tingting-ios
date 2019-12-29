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
            LabelCellConfigurator(),
            MyTeamCellConfigurator(),
            MyTeamCellConfigurator(),

            LabelCellConfigurator(),
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


