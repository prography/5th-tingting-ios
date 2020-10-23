//
//  RxCocoa+Extension.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
    
    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func driveNext<Object: AnyObject>(weak obj: Object, _ onNext: @escaping (Object) -> (Element) -> Void) -> Disposable {
        return self.drive(onNext: weakify(obj, method: onNext))
    }
    
    public func driveNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.drive(onNext: onNext)
    }
   
    /**
     Leverages instance method currying to provide a weak wrapper around an instance function
     
     - parameter obj:    The object that owns the function
     - parameter method: The instance function represented as `InstanceType.instanceFunc`
     */
    func weakify<Object: AnyObject, Input>(_ obj: Object, method: ((Object) -> (Input) -> Void)?) -> ((Input) -> Void) {
        return { [weak obj] value in
            guard let obj = obj else { return }
            method?(obj)(value)
        }
    }
    
    func weakify<Object: AnyObject>(_ obj: Object, method: ((Object) -> () -> Void)?) -> (() -> Void) {
        return { [weak obj] in
            guard let obj = obj else { return }
            method?(obj)()
        }
    }
}
