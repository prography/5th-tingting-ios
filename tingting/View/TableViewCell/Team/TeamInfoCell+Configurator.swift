//
//  TeamInfoCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class TeamInfoCellConfigurator<T: TeamInfoCell>: CellConfigurator {
    var cellType: BaseCellProtocol.Type { T.self }
    
    func configure(_ cell: BaseCellProtocol) {
        
    }
  
}
