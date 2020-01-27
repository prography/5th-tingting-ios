//
//  APIModel+TeamList.swift
//  tingting
//
//  Created by 김선우 on 1/18/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    struct TeamList: Codable {
        private let teamList: [TeamDetail]
        
    }
}


extension APIModel.TeamList {
    
    func getTeamList() -> [Team] {
        
        return teamList.map { $0.getTeam() }
    }
}

extension APIModel.TeamList {
    
    struct TeamDetail: Codable {
        let id: Int
        let owner_id: Int
        let teamMembersInfo: [User]?
        let membersInfo: [User]?
        let name: String
        let max_member_number: Int
        
        let place: String?
        
        func getTeam() -> Team {
            Team(teamInfo: .init(id: id,
                                 name: name,
                                 chat_address: nil,
                                 owner_id: owner_id,
                                 intro: nil,
                                 gender: nil,
                                 password: nil,
                                 max_member_number: max_member_number,
                                 is_verified: nil,
                                 place: place
                ),
                 teamMembers: teamMembersInfo ?? membersInfo ?? [])
        }
    }
 
}
