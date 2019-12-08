//
//  UITableView+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

extension UITableView {
    open func register<T: UITableViewCell>(_ cell: T.Type) {
        let className = cell.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func dequeueReusableBaseCell<T: BaseCell>(type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier) as? BaseCell
            else {
                fatalError("BaseCell must exist.")
        }
        
        guard let typeCell = cell as? T else {
            fatalError("BaseCell must exist.")
        }
        return typeCell
    }
}
