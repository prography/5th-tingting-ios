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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    static func initiate() -> MyTeamViewController {
        let vc = MyTeamViewController.withStoryboard(storyboard: .team)
        return vc
    }
}

