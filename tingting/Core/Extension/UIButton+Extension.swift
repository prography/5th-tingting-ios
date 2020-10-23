//
//  UIButton+Extension.swift
//  tingting
//
//  Created by 김선우 on 1/7/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit

extension UIButton {
    private func setBackgroundColor(isValid: Bool) {
        
        let gradient: CAGradientLayer
        let gradients = self.layer.sublayers?.filter { $0 is CAGradientLayer }
        if let oldGradient = gradients?.first as? CAGradientLayer {
            gradient = oldGradient
        } else {
            gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            gradient.frame = bounds
            layer.insertSublayer(gradient, at: 0)
            
        }
  
        UIView.animate(withDuration: 0.3) {
            if isValid {
                gradient.colors = [ #colorLiteral(red: 1, green: 0.4352941176, blue: 0.3803921569, alpha: 1), #colorLiteral(red: 1, green: 0.5490196078, blue: 0.2823529412, alpha: 1) ].map { $0.cgColor }
            } else {
                gradient.colors = [ #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7843137255, alpha: 1) ].map { $0.cgColor }
            }
        }
    }
    
    func setEnable(_ isEnable: Bool) {
        self.setBackgroundColor(isValid: isEnable)
        self.isEnabled = isEnable
    }
}
