//
//  UIImageView+Extension.swift
//  tingting
//
//  Created by 김선우 on 1/12/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: String?) {
        if let url = url, !url.isEmpty {
            setImage(URL(string: url))
        } else {
            setImage(nil)
        }
    }
    
    func setImage(url: URL?) {
        setImage(url)
    }
    
    private func setImage(_ url: URL?) {
        self.contentMode = .scaleAspectFill
        let placeholder = UIImage(named: "user_placeholder")
        
        
        guard let url = url else {
            image = placeholder
            return }
        self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(1))], progressBlock: nil) 
    }
    
    
}
