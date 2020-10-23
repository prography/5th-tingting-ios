//
//  HasLet.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

protocol HasLet { }

extension HasLet {
    func lets(_ clousure: (Self) -> Void) {
        clousure(self)
    }
}

extension NSObject: HasLet { }
