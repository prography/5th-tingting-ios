//
//  TeamManager.swift
//  tingting
//
//  Created by 김선우 on 1/19/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import RxSwift
import RxCocoa

class TeamManager {
    
    static let shared: TeamManager = TeamManager()
      
    let selectedMyTeamInfo: BehaviorRelay<TeamInfo?> = .init(value: nil)
    
    let myTeamInfos: BehaviorRelay<[TeamInfo]> = .init(value: [])
    let matchingTeamList: BehaviorRelay<[Team]> = .init(value: [])
    
    
    
    
}
