//
//  TeamListView.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TeamListView: BaseView {

    var teamDriver: Driver<Team> {
        return tableView.rx.modelSelected(Team.self).asDriver()
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TeamInfoCell.self)
            
        }
    }
    
    override func bind() {
        
        let teamList = [0, 1, 2, 3].map { _ in TeamInfo() }
        
        Observable.just(teamList)
            .bind(to: tableView.rx.items) { tableView, index, element in
                let cell = tableView.dequeueReusableBaseCell(type: TeamInfoCell.self)
                return cell
        }.disposed(by: disposeBag)
    }
    
    override func commonInit() {
        super.commonInit()
    }
}
