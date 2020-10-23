//
//  Collection+Extension.swift
//  tingting
//
//  Created by 김선우 on 1/12/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}
