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
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var roundedCornerRadius: CGFloat = 0 {
        didSet {
            clipsToBounds = true
            if makeCircle {
                layer.cornerRadius = frame.height / 2
            } else {
                layer.cornerRadius = roundedCornerRadius
            }
        }
    }
    
    @IBInspectable var makeCircle: Bool = false {
        didSet {
            clipsToBounds = true
            if makeCircle {
                layer.cornerRadius = frame.height / 2
                DispatchQueue.main.async {
                    self.layer.cornerRadius = self.frame.height / 2
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
