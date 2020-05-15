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
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
      
    @IBOutlet var tagLabels: [BaseLabel]!
    
    var team: Team!
    var isMyTeam: Bool = false
    
    func configure(with team: Team, isMyTeam: Bool = false) {
        self.team = team
        self.isMyTeam = isMyTeam
        self.bindStyle()
        
        self.baseView.backgroundColor = .clear

        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [ #colorLiteral(red: 1, green: 0.5725490196, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 1, green: 0.4901960784, blue: 0.4392156863, alpha: 1) ].map { $0.cgColor }
        gradient.frame = baseView.bounds
        
        layer.sublayers?.filter { $0 is CAGradientLayer }
                   .forEach { $0.removeFromSuperlayer() }
        layer.insertSublayer(gradient, at: 0)
    } 
    override func bindStyle() {
        // TODO: Add assertionFailure()
        guard let team = self.team else { return }

        titleLabel.text = "\(team.teamInfo.place ?? "") |  \(team.teamInfo.name ?? "")"
        lockImageView.isHidden = team.teamInfo.password == nil
        editButton.isHidden = !isMyTeam
        descriptionLabel.text = team.teamInfo.intro
 
        let currentNumberString = "\(team.teamMembers.count)명"
        let maxNumberString = "/\(team.teamInfo.max_member_number ?? 0)명"
   
        let firstString = NSMutableAttributedString(string: currentNumberString, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let secondString = NSAttributedString(string: maxNumberString, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)])

        firstString.append(secondString)
        memberCountLabel.attributedText = firstString
        
        let tags: [String] =  team.teamInfo.tags ?? []
        tagLabels.enumerated().forEach { index, label in
            
            guard index < tags.count else {
                label.isHidden = true
                return
            }
            
            label.isHidden = false
            label.text = "#" + tags[index]
        }
    }
    
}

