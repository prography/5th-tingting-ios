//
//  M13Checkbox+Extension.swift
//  tingting
//
//  Created by 김선우 on 2/2/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import M13Checkbox

extension M13Checkbox {

    var stateDriver: Driver<M13Checkbox.CheckState> {
        return rx.controlEvent(.valueChanged)
            .map { [weak self] in self?.checkState ?? .unchecked }
            .asDriver(onErrorJustReturn: .unchecked)
    }
     
}
