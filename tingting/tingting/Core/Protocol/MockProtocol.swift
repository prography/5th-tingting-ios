//
//  MockProtocol.swift
//  tingting
//
//  Created by 김선우 on 1/12/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

protocol MockProtocol: Codable {
    associatedtype ResponseType
    
    static func getMockResponse() -> ResponseType

}
