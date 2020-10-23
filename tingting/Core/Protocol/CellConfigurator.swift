//
//  Configuratable.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

protocol Configuratable {
    associatedtype T

    var type: T.Type { get }
    func configure(_ object: Any)
}
