//
//  MatchingTeamListViewController.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa 
import NotificationBannerSwift

class MatchingTeamListViewController: BaseViewController {

    @IBOutlet private weak var introView: TeamIntroView!
 
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
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            return cell
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { _ in
            let vc = MatchingTeamViewController.initiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let banners = ["체고체고", "훈남", "불금불금"]
            .map { "\($0) 팀에서 좋아요를 보냈습니다." }
            .map {
                FloatingNotificationBanner(
                    title: $0,
                    titleFont: .systemFont(ofSize: 13),
                    titleColor: .white,
                    titleTextAlign: .left,
                    style: .info,
                    colors: CustomBannerColors() ) }
        
        banners.forEach {
            $0.show(queuePosition: .front,
                    bannerPosition: .top,
                    queue: .default,
                    cornerRadius: 8,
                    shadowBlurRadius: 0,
                    shadowEdgeInsets: UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 8)
            )
            
        }
        
    }
}

extension MatchingTeamListViewController {
    static func initiate() -> MatchingTeamListViewController {
        let vc = MatchingTeamListViewController.withStoryboard(storyboard: .matching)
        return vc
    }
}
