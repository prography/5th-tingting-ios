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
 
//        let teamInfoView = TeamInfoSwiftUIView()
///        view.addSubview(teamInfoView)
//        let vc = UIHostingController(rootView: teamInfoView)
//        present(vc, animated: true)
        Observable.just((0...10)).bind(to: tableView.rx.items) { tableView, item, index in
            
            let cell = tableView.dequeueReusableBaseCell(type: TeamInfoCell.self)
            return cell
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { _ in

//            let teamInfoView = TeamInfoSwiftUIView()
//            let vc = UIHostingController(rootView: teamInfoView)
            let vc = JoinTeamViewController.initiate()
            self.present(vc, animated: true)
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
