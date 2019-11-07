//
//  Data+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/2/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

extension Data {
    
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
