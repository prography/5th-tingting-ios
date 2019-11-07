//
//  UIViewController+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func fromStoryboard<T>(storyboard: String, className: String, as type: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        guard let rusult = viewController as? T else {
            fatalError("View Controller Couldn't find.")
        }
        
        return rusult
    }
    
    class func withStoryboard(storyboard: String) -> Self {
        
        return fromStoryboard(storyboard: storyboard, className: className, as: self)
    }
    
}
