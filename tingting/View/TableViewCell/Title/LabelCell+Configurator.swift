//
//  LabelCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class LabelCellConfigurator<T: LabelCell> {
    
    let title: String
    let isNew: Bool
    let subtitle: String
    let hasAddButton: Bool
    
    init(title: String, isNew: Bool = false, subtitle: String? = "", hasAddButton: Bool = false) {
        self.title = title
        self.isNew = isNew
        self.subtitle = subtitle ?? ""
        self.hasAddButton = hasAddButton
    }
}

extension LabelCellConfigurator: CellConfigurator {
    var cellType: BaseCellProtocol.Type { T.self }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let labelCell = cell as? T else { return }
        labelCell.lets {
            $0.titleLabel.text = title
            $0.newLabel.isHidden = !isNew
            $0.rightLabel.text = subtitle
            $0.addButton.isHidden = !hasAddButton
        }
    }
}
 
