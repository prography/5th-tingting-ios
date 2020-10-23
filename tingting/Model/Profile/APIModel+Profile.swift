//
//  APIModel+Profile.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    struct Profile: Codable {
        
        let userInfo: User
        
        let myTeamList: [Int]?
        
        let school: [SchoolInfo]?
        
    }
}
extension APIModel {
    struct SchoolInfo: Codable {
        let name: String
    }
}
