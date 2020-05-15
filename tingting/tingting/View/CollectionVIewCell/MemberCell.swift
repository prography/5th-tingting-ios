//
//  MemberCell.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MemberCell: BaseCollectionCell {
    
    @IBOutlet weak var imageView: BaseImageView!
    @IBOutlet weak var teamButton: BaseButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with user: User, isMaster: Bool = false) {
         
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = .init(srgbRed: 189.0 / 255.0, green:  189.0 / 255.0, blue:  189.0 / 255.0, alpha: 1)
        contentView.layer.borderWidth = 0.4
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.08
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        imageView.setImage(url: user.thumbnail)
        teamButton.setTitle( isMaster ? "팀장" : "팀원" , for: .normal)
        teamButton.backgroundColor = UIColor.primary.withAlphaComponent(isMaster ? 1 : 0.5)
        nicknameLabel.text = user.name
    }

}
