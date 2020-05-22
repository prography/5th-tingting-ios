//
//  UISegmentedControl+Extension.swift
//  tingting
//
//  Created by 김선우 on 5/16/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func setSegmentStyle() {
        
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0.3803921569, alpha: 1)
        layer.borderWidth = 1
        
        setBackgroundImage(imageWithColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: #colorLiteral(red: 1, green: 0.4352941176, blue: 0.3803921569, alpha: 1)), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        
        setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 1, green: 0.4352941176, blue: 0.3803921569, alpha: 1)], for: .normal)
        setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .selected)
    }

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
