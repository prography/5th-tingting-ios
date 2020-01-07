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
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = isValid ? .primary : #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7843137255, alpha: 1)
        }
    }
    
    func setEnable(_ isEnable: Bool) {
        self.setBackgroundColor(isValid: isEnable)
        self.isEnabled = isEnable
    }
}
