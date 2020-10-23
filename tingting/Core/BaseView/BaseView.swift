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
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var roundedCornerRadius: CGFloat = 0 {
        didSet {
            clipsToBounds = true
            if makeCircle {
                layer.cornerRadius = frame.height / 2
            } else {
                layer.cornerRadius = roundedCornerRadius
            }
        }
    }
    
    @IBInspectable var makeCircle: Bool = false {
        didSet {
            clipsToBounds = true
            if makeCircle {
                layer.cornerRadius = frame.height / 2
                DispatchQueue.main.async {
                    self.layer.cornerRadius = self.frame.height / 2
                }
            }
        }
    }

    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .blue
    
    @IBInspectable var makeShadow: Bool = false {
        didSet {
            if makeShadow {
                if shadowLayer == nil {
                    shadowLayer = CAShapeLayer()
                    
                    shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
                    shadowLayer.fillColor = self.backgroundColor?.cgColor
                    
                    shadowLayer.borderColor = .primary
                    shadowLayer.borderWidth = 1
                    shadowLayer.shadowColor = UIColor.black.cgColor
                    shadowLayer.shadowPath = shadowLayer.path
                    shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                    shadowLayer.shadowOpacity = 0.2
                    shadowLayer.shadowRadius = 3
                    
                    layer.insertSublayer(shadowLayer, at: 0)
                    
                    let borderLayer = CAShapeLayer()
                    
                    borderLayer.borderColor = .primary
                    borderLayer.borderWidth = 1
                    layer.insertSublayer(borderLayer, at: 1)

                }
            }
        }
    }
      
    override init(frame: CGRect) {
        super.init(frame: frame)  
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.async {
            self.commonInit()
        }
        
    }
    
    func commonInit() {
        let className = self.className
        if className != "BaseView", let view = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UIView {
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
