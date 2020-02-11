//
//  String+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/2/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

extension String {
    var data: Data? {
         data(using: .utf8)
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}
