//
//  BaseLabel.swift
//  tingting
//
//  Created by 김선우 on 12/18/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

@IBDesignable
class BaseLabel: UILabel {
     
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
     
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
