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

    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var tagLabels: [UILabel]!
    
    var team: Team!
    var isMyTeam: Bool = false
    
    func configure(with team: Team, isMyTeam: Bool = false) {
        self.team = team
        self.isMyTeam = isMyTeam
        DispatchQueue.main.async {
            self.bindStyle()
        }
    }
    
    override func bindStyle() {
        
        // TODO: Add assertionFailure()
        guard let team = self.team else { return }
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = .primary

        titleLabel.text = team.teamInfo.name ?? ""
        titleLabel.textColor = isMyTeam ? .white : .primary
        baseView.backgroundColor = isMyTeam ? .primary : .clear
        editButton.isHidden = !isMyTeam
        descriptionLabel.text = team.teamInfo.intro
        
        tagLabels[optional: 0]?.text = team.teamInfo.gender?.korean ?? "성별"
        
        if let maxNumber = team.teamInfo.max_member_number {
            tagLabels[optional: 1]?.text = "\(maxNumber):\(maxNumber)"
        }
        
        tagLabels[optional: 2]?.isHidden = true
        tagLabels[optional: 3]?.isHidden = true
        
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

