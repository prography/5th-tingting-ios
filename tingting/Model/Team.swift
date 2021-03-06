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
    
    var teamMembers: [User] = []
     
    var teamMatchings: [TeamMatching]?
    
    var isHeartSent: Bool? = false
    
    var sortedUser: [User] {
        teamMembers.sorted { user, _ in user.id == teamInfo.owner_id }
    }
    
}

struct TeamMatching: Codable {
    let id: Int
    let is_matched: Bool
    private let sendTeam: APIModel.TeamList.TeamDetail
    func team() -> Team {
        var team = sendTeam.getTeam()
        team.teamInfo.id = team.teamInfo.id ?? id
        return team
    }
}

struct TeamInfo: Codable {

    var id: Int?
    
    let name: String?
    let chat_address: String?
    let owner_id: Int?
    let intro: String?
    let gender: GenderType?
    let password: String?
    let max_member_number: Int?
    let is_verified: Int?
    
    let is_matched: Bool?
    let accepter_number: Int?
    let place: String?
    
    var tags: [String]?
    let tagIds: [Int]?
       
    init() {
        self.id = nil
        self.name = nil
        self.chat_address = nil
        self.owner_id = nil
        self.intro = nil
        self.gender = nil
        self.password = nil
        self.max_member_number = nil
        self.is_verified = nil
        self.is_matched = nil
        self.accepter_number = nil
        self.place = nil
        self.tagIds = nil
        
    }
    init(id: Int? = nil,
         name: String?,
         chat_address: String?,
         owner_id: Int?,
         intro: String?,
         gender: GenderType?,
         password: String?,
         max_member_number: Int?,
         is_verified: Int? = 0,
         is_matched: Bool?,
         accepter_number: Int?,
         place: String?,
         tagIds: [Int]?
    ) {
        self.id = id
        self.name = name
        self.chat_address = chat_address
        self.owner_id = owner_id
        self.intro = intro
        self.gender = gender
        self.password = password
        self.max_member_number = max_member_number
        self.is_verified = is_verified
        self.is_matched = is_matched
        self.accepter_number = accepter_number
        self.place = place
        self.tagIds = tagIds
    }
}
//
//struct MockTeam: MockProtocol {
//    typealias ResponseType = Team
//    
//    static func getMockResponse() -> Team {
//        
//        let teamInfo = TeamInfo (id: 1,
//                                 name: "랄랄라",
//                                 chat_address: "www.kakaomockData.com",
//                                 owner_id: 1,
//                                 intro: "Mock 안녕하세요 반가워요",
//                                 gender: .male,
//                                 password: nil,
//                                 max_member_number: 3,
//                                 is_verified: 1 )
//        
//        let users: [User] = [
//            User(name: "랄랄라",
//                 birth: "1993-09-02",
//                 height: 178,
//                 thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbjVTjup5Hl5AtrYqSxv1JUMR7bTrOPn4cX_ZQcCgKxJh6LHee&s",
//                 gender: .male,
//                 is_deleted: 0),
//            
//            User(name: "안녕안녕",
//                 birth: "1993-09-01",
//                 height: 170,
//                 thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWV2hAptWGKbUKg0vxUlkQXx8sDDm_YL0yWtgwlFndX-qf1Isu&s",
//                 gender: .male,
//                 is_deleted: 0),
//            
//            User(name: "랄랄라",
//                 birth: "1996-11-22",
//                 height: 172,
//                 thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT59wJf85eT6HmkyI8ODvlffumYtdVy39KdrHRRoHrYZYBoYGF2&s",
//                 gender: .male,
//                 is_deleted: 0)
//        ]
//        
//        
//        return Team(teamInfo: teamInfo, teamMembers: users)
//    }
//}
