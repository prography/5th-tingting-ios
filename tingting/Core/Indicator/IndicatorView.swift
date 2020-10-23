//
//  IndicatorView.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class IndicatorView
{
    var container = UIView()
    var indicator = UIActivityIndicatorView()
    
    static let shared: IndicatorView = { return IndicatorView() } ()
    
    func show(parentView: UIView, backgroundColor: UIColor) {
        
        container.lets {
            $0.frame = parentView.frame
            $0.center = parentView.center
            $0.backgroundColor = backgroundColor
            $0.clipsToBounds = true
            parentView.addSubview($0)
        }
        
        indicator.lets {
            $0.center = container.center
            $0.startAnimating()
            $0.style = .large
            container.addSubview($0)
        }
    }
  
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.stopAnimating()
            self?.container.removeFromSuperview()
        }
    }
}

