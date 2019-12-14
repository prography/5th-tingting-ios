//
//  TeamIntroView.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class TeamIntroView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var tagLabels: [UILabel]!
    
    func initiate(title: String, tags: [String], description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        tagLabels.enumerated().forEach { index, label in
            
            guard index < tags.count else {
                label.isHidden = true
                return
            }
            
            label.isHidden = false
            label.text = tags[index]
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
        }
    }
    
    override func bindStyle() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = .primary
    }
    
}

