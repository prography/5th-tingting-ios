//
//  JoinTeamCell.swift
//  tingting
//
//  Created by 김선우 on 12/31/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class JoinTeamCell: BaseCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var tagLabel: UILabel! {
        didSet {
            tagLabel.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
