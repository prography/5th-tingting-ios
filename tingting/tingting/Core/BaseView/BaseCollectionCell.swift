//
//  BaseCollectionCell.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    static var identifier: String { className }
    
    func configure(with cellModel: BaseCollectionCellModelType) {
        
    }
}

protocol BaseCollectionCellModelType {
    var cellType: BaseCollectionCell.Type { get }
}
