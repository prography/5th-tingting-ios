//
//  TeamIntroView.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

@IBDesignable
class TeamIntroView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var tagLabels: [UILabel]!
    
    var team: Team!
    
    func configure(with team: Team) {
        self.team = team
        
    }
    
    override func bindStyle() {
        
        // TODO: Add assertionFailure()
        guard let team = self.team else { return }
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = .primary
         
        titleLabel.text = team.teamInfo.name ?? ""
        descriptionLabel.text = team.teamInfo.intro
        
        // TODO: Add Tag
        //        tagLabels.enumerated().forEach { index, label in
        //
        //            guard index < tags.count else {
        //                label.isHidden = true
        //                return
        //            }
        //
        //            label.isHidden = false
        //            label.text = tags[index]
        //            label.layer.cornerRadius = 5
        //            label.clipsToBounds = true
        //        }
    }
    
}

