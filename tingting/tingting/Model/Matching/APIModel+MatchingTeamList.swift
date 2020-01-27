//
//  APIModel+MatchingTeamList.swift
//  tingting
//
//  Created by 김선우 on 1/19/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    struct MatcingTeamList: Codable {
        var myTeamList: [TeamInfo] = []
        private let matchingList: [MatchingTeam]
 
        func matchingTeamList() -> [Team] {
            return matchingList.map { $0.team() }
        }
    }
    
    // MARK: - MatchingList
    struct MatchingTeam: Codable {
        let id: Int
        let owner_id: Int
        let name: String
        let max_member_number: Int
        let membersInfo: [User]
        
        func team() -> Team {
            
            let teamInfo = TeamInfo(id: id,
                                    name: name,
                                    chat_address: nil,
                                    owner_id: owner_id,
                                    intro: nil,
                                    gender: nil,
                                    password: nil,
                                    max_member_number: max_member_number,
                                    is_verified: nil,
                                    is_matched: nil,
                                    accepter_number: nil,
                                    place: nil)
            
            return Team(teamInfo: teamInfo, teamMembers: membersInfo)
        }
    }
}
