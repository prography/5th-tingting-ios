//
//  User.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var name: String?
    var birth: String?
    var height: Int?
    var thumbnail: String?
    var gender: Int? // 0 - 남자, 1 - 여자
    var is_deleted: Int
    
}
