//
//  SpaceCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 1/5/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//
 
import UIKit

class SpaceCellConfigurator<T: SpaceCell> {
    
    let height: CGFloat
     
    init(_ height: CGFloat) {
        self.height = height
    }
}

extension SpaceCellConfigurator: CellConfigurator {
    var cellType: BaseCellProtocol.Type { T.self }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let spaceCell = cell as? T else { return }
        
        spaceCell.cellHeightConstraint.constant = self.height
        
    }
}
