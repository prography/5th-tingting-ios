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
    
    @IBOutlet weak var teamIntroView: TeamIntroView!
    @IBOutlet weak var memberListView: MemberListView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.didSetDefault()
        }
    }
    
    private var teamID: Int!
    private var team: Team?
    
    var items: BehaviorRelay<[CellConfigurator]> = .init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyTeamInfo()
        startLoading()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func bind() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        items.bind(to: tableView.rx.items) { tableView, index, configurator in
            let cell = tableView.configuredBaseCell(with: configurator)
            cell.selectionStyle = .none
            
            if let matchingCell = cell as? MyMatchingTeamCell,
                let configurator = configurator as? MyMatchingTeamCellConfigurator {
                
                let team = configurator.teamMatching.team()
                
                matchingCell.lets {
                    
                    $0.applyButton.rx.tap
                        .bind { [weak self] in
                            guard let self = self else { return }
                            self.startLoading(backgroundColor: .clear)
                            NetworkManager.acceptMatching(matchingID: configurator.teamMatching.id)
                                .asObservable()
                                .subscribe(
                                    onNext: { [weak self] response in
                                        AlertManager.show(title: response.message)
                                        self?.getMyTeamInfo()
                                        
                                },
                                    onError: { [weak self] error in
                                        AlertManager.showError(error)
                                        self?.endLoading()
                                        
                                }
                            ).disposed(by: self.disposeBag)
                    }.disposed(by: matchingCell.disposeBag)
                    
                    $0.rejectButton.rx.tap
                        .bind {
                            
                            AlertManager.show(title: "해당 기능은 개발 중에 있습니다 조금만 기다려주세요!")
                            
                    }.disposed(by: matchingCell.disposeBag)
                    
                    $0.chatAddressButton.rx.tap
                        .bind { [weak self] in
                            
                            guard let chatAddress = team.teamInfo.chat_address else { assertionFailure(); return }
                            let alert = UIAlertController(title: "", message: chatAddress, preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                            
                            let copyAction = UIAlertAction(title: "복사하기", style: .default) { action in
                                UIPasteboard.general.string = chatAddress
                                AlertManager.show(title: "주소를 복사했습니다!")
                            }
                            
                            let openAction = UIAlertAction(title: "열기", style: .default) { action in
                                if let url = URL(string: chatAddress) {
                                    UIApplication.shared.open(url, options: [:])
                                }
                            }
                            
                            alert.addAction(cancelAction)
                            alert.addAction(copyAction)
                            alert.addAction(openAction)
                            
                            self?.present(alert, animated: true, completion: nil)
                            
                    }.disposed(by: matchingCell.disposeBag)
                    
                }

            }
            
            return cell
        }.disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(CellConfigurator.self)
            .bind { [weak self] configurator in
                guard let self = self else { return }
                if let configurator = configurator as? MyMatchingTeamCellConfigurator {
                    let vc = MatchingTeamViewController.initiate(myTeamID: nil, team: configurator.teamMatching.team())
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }.disposed(by: disposeBag)
        
        teamIntroView.editButton.rx.tap
            .bind { [weak self] in
                guard let team = self?.team else { assertionFailure(); return }
                
                let vc = CreateTeamViewController.initiate(teamType: .edit(team: team))
                self?.navigationController?.pushViewController(vc, animated: true)
                
        }.disposed(by: disposeBag)
        
    }
    

}

extension MyTeamViewController {
    
    func getMyTeamInfo() {
        startLoading(backgroundColor: .clear)
        NetworkManager.getMyTeamInfo(id: teamID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] team in
                    guard let self = self else { return }
                    self.team = team
                    self.teamIntroView.configure(with: team, isMyTeam: true)
                    self.memberListView.configure(with: team.sortedUser)
                    self.makeConfigurator()
                    self.endLoading()
                },
                onError: { [weak self] error in
                    self?.endLoading()
                    AlertManager.showError(error)
                }
        ).disposed(by: disposeBag)
    }
    
    func makeConfigurator() {
        guard let team = team, let matchingInfos = team.teamMatchings else { return }
        
        let hasNew = matchingInfos.first { !$0.is_matched } != nil
         
        let title = [ LabelCellConfigurator(title: "매칭 현황",
                                            isNew: hasNew,
                                            subtitle: matchingInfos.isEmpty ? "매칭 없음" : "매칭 진행 중",
                                            hasAddButton: false)
        ]
        
        let matcingTeams = matchingInfos.map { MyMatchingTeamCellConfigurator($0) }

        let configurators: [CellConfigurator] = title + matcingTeams
        
        items.accept(configurators)

    }
    
}

extension MyTeamViewController {
    static func initiate(teamID: Int) -> MyTeamViewController {
        let vc = MyTeamViewController.withStoryboard(storyboard: .team)
        vc.teamID = teamID
        return vc
    }
}

