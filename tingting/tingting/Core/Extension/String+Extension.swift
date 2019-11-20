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
