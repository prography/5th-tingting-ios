//
//  ColorType.swift
//  tingting
//
//  Created by 김선우 on 11/23/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    static var primaryColor: Color {
     return Color(red: 255.0 / 255.0, green: 125.0 / 255.0, blue: 112.0 / 255.0)
    }
}

extension UIColor {
    static var primary: UIColor {
        return #colorLiteral(red: 1, green: 0.5744549632, blue: 0.5127008557, alpha: 1)
    }
}

extension CGColor {
    static var primary: CGColor {
        return #colorLiteral(red: 1, green: 0.5744549632, blue: 0.5127008557, alpha: 1)
    }
    static var clear: CGColor {
        return UIColor.clear.cgColor
    }
}
