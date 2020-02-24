//
//  Validator.swift
//  tingting
//
//  Created by 김선우 on 1/7/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

struct Validator {
    static func check(email: String?) -> Bool {
        guard let email = email else { return false }
        return email == email.filterString(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
}
