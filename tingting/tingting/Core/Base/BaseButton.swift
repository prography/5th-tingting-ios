//
//  BaseButton.swift
//  tingting
//
//  Created by 김선우 on 12/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift

@IBDesignable
class BaseButton: UIButton {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var roundedCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = roundedCornerRadius
        }
    }
    
}
