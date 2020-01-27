//
//  MatchingTeamStateCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MatchingTeamStateCellConfigurator<T: MatchingTeamStateCell>: CellConfigurator {
    
    let matchingInfo: APIModel.MatchingInfo
    var cellType: BaseCellProtocol.Type { T.self }
    
    init(_ matchingInfo: APIModel.MatchingInfo) {
        self.matchingInfo = matchingInfo
    }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let cell = cell as? MatchingTeamStateCell else { return }
        cell.teamNameLabel.text = matchingInfo.receiveTeam.name ?? ""
        
    }
     
}
