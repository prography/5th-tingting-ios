//
//  GenderType.swift
//  tingting
//
//  Created by 김선우 on 1/15/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

enum GenderType: Int, Codable {
    case male = 0
    case female = 1
    
    var korean: String {
        switch self {
        case .male:
            return "남자"
            
        case .female:
            return "여자"
            
        }
    }
}
