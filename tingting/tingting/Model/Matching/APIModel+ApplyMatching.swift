//
//  APIModel+ApplyMatching.swift
//  tingting
//
//  Created by 김선우 on 1/25/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    enum ApplyMatching {
        struct Request: Codable {
            var receiveTeamId: Int?
            var sendTeamId: Int?
            var message: String?
        }
    }
}
