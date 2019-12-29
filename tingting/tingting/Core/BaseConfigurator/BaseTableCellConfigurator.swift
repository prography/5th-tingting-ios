//
//  BaseTableCellConfigurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

protocol CellConfigurator {
    var cellType: BaseCellProtocol.Type { get }
    func configure(_ cell: BaseCellProtocol)
}
