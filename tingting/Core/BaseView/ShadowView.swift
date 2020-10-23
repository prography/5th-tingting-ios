//
//  ShadowView.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var makeShadow: Bool = false {
        didSet {
            guard makeShadow else { return }
            backgroundColor = .clear
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 1.0)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 4.0
        }
    }
    

}
