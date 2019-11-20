//
//  BaseCell.swift
//  tingting
//
//  Created by 김선우 on 9/2/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    static var identifier: String { className }
    
    func configure(with cellModel: BaseCellModelType) {
        
    }
}

protocol BaseCellModelType {
    var cellType: BaseCell.Type { get }
}
