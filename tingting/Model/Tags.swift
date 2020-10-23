//
//  Tags.swift
//  tingting
//
//  Created by 김선우 on 5/9/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

struct TeamTag: Equatable {
    let id: Int
    let name: String
}

let tagList: [TeamTag] = [
    .init(id: 1,  name: "술고래"),
    .init(id: 2,  name: "술찌"),
    .init(id: 3,  name: "술게임선호"),
    .init(id: 4,  name: "활발한"),
    .init(id: 5,  name: "재밌는"),
    .init(id: 6,  name: "털털한"),
    .init(id: 7,  name: "착한"),
    .init(id: 8,  name: "귀여운"),
    .init(id: 9,  name: "예쁜"),
    .init(id: 10, name: "잘생긴"),
    .init(id: 11, name: "긍정적"),
    .init(id: 12, name: "엉뚱한"),
    .init(id: 13, name: "도른자"),
    .init(id: 14, name: "새내긔"),
    .init(id: 15, name: "정든내기"),
    .init(id: 16, name: "첫미팅"),
    .init(id: 17, name: "당일미팅")
]
