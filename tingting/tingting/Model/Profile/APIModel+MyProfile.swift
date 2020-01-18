//
//  APIModel+MyProfile.swift
//  tingting
//
//  Created by 김선우 on 1/8/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    struct MyProfile: Codable {
        
        let myInfo: User
        
        let myTeamList: [TeamInfo]?
          
    }
}
