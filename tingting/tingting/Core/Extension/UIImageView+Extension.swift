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
         
        var options: KingfisherOptionsInfo? = [.transition(.fade(1))]
        
        if let token = ConnectionManager.shared.loadToken() {
            let modifier = AnyModifier { request in
                var request = request
                // replace "Access-Token" with the field name you need, it's just an example
                request.setValue(token, forHTTPHeaderField: "Authorization")
                return request
            }
            options? += [.requestModifier(modifier)]
        }
        
        guard let url = url else { image = placeholder; return }
        self.kf.setImage(with: url, placeholder: placeholder, options: options, progressBlock: nil)
    }
    
    
}
