//
//  APIModel+Login.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension APIModel {
    enum Login {}
}

extension APIModel.Login {
    struct Request: Codable {
        private var local_id: String
        var password: String
        
        var id: String {
            get { return local_id }
            set { local_id = newValue }
        }
        
        init(id: String, password: String) {
            self.local_id = id
            self.password = password
        }
    }
    
    struct Response: Codable {
        let message: String
        let token: String
    }
}
