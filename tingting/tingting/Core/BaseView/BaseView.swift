//
//  BaseView.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift

@IBDesignable
class BaseView: UIView {
    let disposeBag = DisposeBag()
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
     
    @IBInspectable var roundedCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = roundedCornerRadius
        }
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)  
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let className = self.className
        
        if let view = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
        bind()
        bindStyle()
    }
    
    func bind() {
        
    }
    
    func bindStyle() {
        
    }
}
