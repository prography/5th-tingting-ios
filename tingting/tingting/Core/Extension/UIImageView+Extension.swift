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
        let url = url != nil ? URL(string: url!) : nil
        setImage(url)
    }
    
    func setImage(url: URL?) {
        setImage(url)
    }
    
    private func setImage(_ url: URL?) {
        self.contentMode = .scaleAspectFill
        
        self.kf.setImage(with: url, placeholder: UIImage(named: "user_placeholder"), options: [.transition(.fade(1))], progressBlock: nil) { result in
            
            switch result {
            case .success:
                break
            case .failure(let error):
                Logger.error(error)
            }
        }
    }
    
    
}
