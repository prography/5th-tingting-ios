//
//  BaseCell.swift
//  tingting
//
//  Created by 김선우 on 9/2/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
 
class BaseCell: UITableViewCell, BaseCellProtocol {
      
    let disposeBag = DisposeBag()
    
    static var identifier: String { className }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    func configure(with cellModel: BaseCellModelType) {
        setStyle()
    }
    
    func setStyle() {
        
    }
}

protocol BaseCellModelType {
    var cellType: BaseCell.Type { get }
}
