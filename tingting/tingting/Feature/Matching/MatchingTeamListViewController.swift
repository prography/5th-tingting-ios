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
import DropDown
import NotificationBannerSwift

class MatchingTeamListViewController: BaseViewController {
 
    @IBOutlet weak var teamButton: BaseButton!
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.didSetDefault()
           }
       }
    
    lazy var teamDropDown: DropDown = {
        let dropdown = DropDown()
        dropdown.bottomOffset = CGPoint(x: -20, y: teamButton.bounds.height + 13)
        dropdown.anchorView = teamButton
        return dropdown
    }()
    
    private let items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
      
    private let teamManager = TeamManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Remove
//        let configurators = (0...20).map { _ -> JoinTeamCellConfigurator<JoinTeamCell> in
//            let team = Team(teamInfo: .init())
//            return JoinTeamCellConfigurator(team: team)
//        }
//        items.accept(configurators)
        setDropDown()
        
        
        getMatchingTeamList()
        
    }
    
    override func bind() {
         
        teamButton.rx.tap
            .bind { [weak self] in
                self?.teamDropDown.show()
        }.disposed(by: disposeBag)
        
        teamDropDown.selectionAction = { [weak self] index, item in
            let teamInfos = TeamManager.shared.myTeamInfos.value
            let teamInfo = teamInfos.first { $0.name == item }
            self?.teamManager.selectedMyTeamInfo.accept(teamInfo)
        }
         
        teamManager.selectedMyTeamInfo
            .compactMap { $0 }
            .bind { [weak self] teamInfo in
                self?.teamButton.setTitle(teamInfo.name, for: .normal)
                self?.loadTeamList()
        }.disposed(by: disposeBag)
        
        teamManager.myTeamInfos
            .bind { [weak self] teamInfos in
                self?.teamDropDown.dataSource = teamInfos.compactMap { $0.name }
                self?.teamDropDown.reloadAllComponents()
        }.disposed(by: disposeBag)
        
        teamManager.matchingTeamList
            .bind { [weak self] _ in
                self?.loadTeamList()
        }.disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            return cell
        }.disposed(by: disposeBag)
        
         
        
        tableView.rx.itemSelected.bind { [weak self] in
            guard let self = self else { return }
            let team = self.teamManager.matchingTeamList.value[$0.row]
            let vc = MatchingTeamViewController.initiate(to: team)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension MatchingTeamListViewController {
    func getMatchingTeamList() {
        startLoading(backgroundColor: .clear)
        
        NetworkManager.getAllMatchingList()
            .asObservable()
            .subscribe(
                onNext: { [weak self] response in
                    
                    self?.teamManager.myTeamInfos.accept(response.myTeamList)
                    self?.teamManager.matchingTeamList.accept(response.matchingTeamList())
                      
                    self?.endLoading()
 
                },
                onError: { [weak self] error in
                    AlertManager.showError(error)
                    self?.endLoading()
            }
        ).disposed(by: disposeBag)
    }
    
    func loadTeamList() {
        
        let selectedTeam = teamManager.selectedMyTeamInfo.value
        
        let teamList = teamManager.matchingTeamList.value
            .filter { $0.teamInfo.max_member_number! == selectedTeam?.max_member_number }
        
        let configurator = teamList.map(JoinTeamCellConfigurator.init)
        
        items.accept(configurator)
    }
    
    func setDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //        appearance.textFont = UIFont(name: "Georgia", size: 14)
    }
    
    
    func showBanner() {
        
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
