//
//  APIModel+CommonResponse.swift
//  tingting
//
//  Created by 김선우 on 1/3/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

struct CommonReponse: Codable {
    let message: String
}

struct MockCommonReponse: MockProtocol {
    typealias ResponseType = CommonReponse
    
    static func getMockResponse() -> CommonReponse {
        return .init(message: "Mock Data ~")
    }
}
