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
    
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configurators = (0...20).map { _ in JoinTeamCellConfigurator() }
        items.accept(configurators)
    }
    
    override func bind() {
        
        creatTeamButton.rx.tap.bind {
            let createTeamVC = CreateTeamViewController.initiate()
            self.present(createTeamVC, animated: true)
        }.disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            return cell
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { _ in
            let vc = JoinTeamViewController.initiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension TeamListViewController {
    static func initiate() -> TeamListViewController {
        let vc = TeamListViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
