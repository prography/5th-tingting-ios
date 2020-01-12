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
    init(name: String?,
         chat_address: String?,
         owner_id: Int?,
         intro: String?,
         gender: Int?,
         password: String?,
         max_member_number: Int?,
         is_verified: Int?
    ) {
        self.name = name
        self.chat_address = chat_address
        self.owner_id = owner_id
        self.intro = intro
        self.gender = gender
        self.password = password
        self.max_member_number = max_member_number
        self.is_verified = is_verified
    }
}

struct MockTeam: MockProtocol {
    typealias ResponseType = Team
    
    static func getMockResponse() -> Team {
        
        let teamInfo = TeamInfo (name: "랄랄라",
                                 chat_address: "www.kakaomockData.com",
                                 owner_id: 1,
                                 intro: "Mock 안녕하세요 반가워요",
                                 gender: 0,
                                 password: nil,
                                 max_member_number: 3,
                                 is_verified: 1 )
        
        let users: [User] = [
            User(name: "랄랄라",
                 birth: "1993-09-02",
                 height: 178,
                 thumbnail: "https://www.google.com/imgres?imgurl=http%3A%2F%2Fimage.news1.kr%2Fsystem%2Fphotos%2F2019%2F1%2F25%2F3485271%2Farticle.jpg&imgrefurl=http%3A%2F%2Fnews1.kr%2Fphotos%2Fview%2F%3F3485271&docid=u6RmwLRcDRJlKM&tbnid=zZgmwAkkzs4tsM%3A&vet=10ahUKEwjLyoGw6v3mAhUb_GEKHZU9CaMQMwiYASglMCU..i&w=560&h=776&itg=1&bih=750&biw=1344&q=%EB%9E%9C%EC%84%A0%EB%82%A8%EC%B9%9C&ved=0ahUKEwjLyoGw6v3mAhUb_GEKHZU9CaMQMwiYASglMCU&iact=mrc&uact=8",
                 gender: 0,
                 is_deleted: 0),
            
            User(name: "안녕안녕",
                 birth: "1993-09-01",
                 height: 170,
                 thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWV2hAptWGKbUKg0vxUlkQXx8sDDm_YL0yWtgwlFndX-qf1Isu&s",
                 gender: 0,
                 is_deleted: 0),
            
            User(name: "랄랄라",
                 birth: "1996-11-22",
                 height: 172,
                 thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT59wJf85eT6HmkyI8ODvlffumYtdVy39KdrHRRoHrYZYBoYGF2&s",
                 gender: 0,
                 is_deleted: 0)
        ]
        
        
        return Team(teamInfo: teamInfo, members: users)
    }
}
