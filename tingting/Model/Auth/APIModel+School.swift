//
//  APIModel+School.swift
//  tingting
//
//  Created by 김선우 on 1/3/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    enum School {}
}

extension APIModel.School {
    struct Request: Codable {
        var email: String
    }
}
