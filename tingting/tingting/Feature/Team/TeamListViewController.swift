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
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.register(TeamInfoCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        Observable.just((0...10)).bind(to: tableView.rx.items) { tableView, item, index in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamInfoCell.identifier) else {
                fatalError("Cell must exist.")
            }
            return cell
        }.disposed(by: disposeBag)
        
        
    }
 
}
