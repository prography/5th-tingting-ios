//
//  Team.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

struct Team: Codable {
    
    var teamInfo: TeamInfo
    
    var members: [User] = []
    
    
}

struct TeamInfo: Codable {

    let name: String?
    let chat_address: String?
    let owner_id: Int?
    let intro: String?
    let gender: Int?
    let password: String?
    let max_member_number: Int?
    let is_verified: Int?
    
    init() {
        
        self.name = nil
        self.chat_address = nil
        self.owner_id = nil
        self.intro = nil
        self.gender = nil
        self.password = nil
        self.max_member_number = nil
        self.is_verified = nil
        
    }
}
