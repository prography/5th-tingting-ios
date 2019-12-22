//
//  StoryboardType.swift
//  tingting
//
//  Created by 김선우 on 11/17/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

enum StoryboardType {
    
    case user
    case team
    case matching
    case setting
    case member
    
    var fileName: String {
        switch self {
        case .user:
            return "User"
            
        case .team:
            return "Team"
            
        case .matching:
            return "Matching"
            
        case .setting:
            return "Setting"
            
        case .member:
            return "Member"
            
        }
    }
    
}
