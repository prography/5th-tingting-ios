//
//  NSObject+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            print(String(describing: self))
            fatalError("Class name couldn't find.")
        }
        return className
    }
    
    var className: String { 
        guard let className = String(describing: self)
            .components(separatedBy: ":").first?
            .components(separatedBy: ".").last
             else {
                
            print(String(describing: self))
            fatalError("Class name couldn't find.")
        }
        return className
    }
    
    
} 
