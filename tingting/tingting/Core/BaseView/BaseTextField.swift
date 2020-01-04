//
//  BaseTextField.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit

@IBDesignable
class BaseTextField: UITextField {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
     
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
      
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return super.textRect(forBounds: bounds.inset(by: insets))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
