//
//  JoinTeamCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/31/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//
 
import UIKit

class JoinTeamCellConfigurator<T: JoinTeamCell>: CellConfigurator {
    
    let team: Team
    
    var cellType: BaseCellProtocol.Type { T.self }
    
    func configure(_ cell: BaseCellProtocol) {
        
    }
    
    init(team: Team) {
        self.team = team
    }
  
}


