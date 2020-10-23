//
//  UICollectionView+Extension.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

extension UICollectionView {
    open func register<T: UICollectionViewCell>(_ cell: T.Type) {
        let className = cell.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableBaseCell<T: BaseCollectionCell>(type: T.Type, for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? BaseCollectionCell
            else {
                fatalError("BaseCollectionCell must exist.")
        }
        
        guard let typeCell = cell as? T else {
            fatalError("BaseCollectionCell must exist.")
        }
        
        return typeCell
    }
}
