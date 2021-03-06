//
//  APIModel+SignUp.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    enum SignUp {}
}

extension APIModel.SignUp {
    
    struct Request: Codable {
        var local_id: String?
        var password: String?
        var gender: GenderType?
        var name: String?
        var birth: String? // 1993-09-02
        var thumbnail: String? = ""
        var authenticated_address: String?
        var height: Int?
    }
    
    struct Response: Codable {
        let message: String
        let token: String
    }
}
