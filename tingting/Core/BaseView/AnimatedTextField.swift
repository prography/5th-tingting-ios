//
//  AnimatedTextField.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import TextFieldEffects

@IBDesignable
class AnimatedTextField: TextFieldEffects {
    
    @IBInspectable var activeBorderSize: CGFloat = 2
    @IBInspectable var inactiveBorderSize: CGFloat = 2
    @IBInspectable var textFieldInset: CGFloat = 6.0
    @IBInspectable var placeholderInset: CGFloat = 6.0
    
    private let borderLayer = CALayer()
    private var borderSize: (active: CGFloat, inactive: CGFloat) {
        return (activeBorderSize, inactiveBorderSize)
    }
    
    private var textFieldInsets: CGPoint {
        return CGPoint(x: textFieldInset, y: 0)
    }
    private var placeholderInsets: CGPoint {
        return CGPoint(x: placeholderInset, y: 0)
    }
     
    
//     override func textRect(forBounds bounds: CGRect) -> CGRect {
//         let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//         return super.textRect(forBounds: bounds.inset(by: insets))
//     }
//
//     override func editingRect(forBounds bounds: CGRect) -> CGRect {
//         return textRect(forBounds: bounds)
//     }
    
    /**
     The color of the border.
     
     This property applies a color to the bounds of the control. The default value for this property is a clear color.
    */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
        }
    }
    
    // MARK: TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        
        addSubview(placeholderLabel)
        layer.addSublayer(borderLayer)
    }
    
    override open func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.17, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        }, completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        UIView.animate(withDuration: 0.17, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        }, completion: { _ in
            self.animationCompletionHandler?(.textDisplay)
        })
    }
    
    // MARK: Private
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = (isFirstResponder || !text!.isEmpty) ? borderSize.active : borderSize.inactive
        borderLayer.borderColor = borderColor?.cgColor
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private var placeholderHeight : CGFloat {
        return placeholderInsets.y + placeholderFontFromFont(font!).lineHeight
    }
    
    private func rectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }
    
    // MARK: - Overrides
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || !text!.isEmpty {
            return CGRect(x: placeholderInsets.x, y: placeholderInsets.y, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y + placeholderHeight/2)
    }
}
