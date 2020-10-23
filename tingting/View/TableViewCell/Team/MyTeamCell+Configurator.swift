//
//  MyTeamCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit


class MyTeamCellConfigurator<T: MyTeamCell>: CellConfigurator {
    
    let teamInfo: TeamInfo
    
    var cellType: BaseCellProtocol.Type { T.self }
    
    init(teamInfo: TeamInfo) {
        self.teamInfo = teamInfo
    }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let cell = cell as? T else { return }
        cell.teamInfo = teamInfo
        cell.teamNameLabel.text = teamInfo.name
        cell.newLabel.isHidden = true
    }
 
}
