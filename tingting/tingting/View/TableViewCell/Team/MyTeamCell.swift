//
//  MyTeamCell.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MyTeamCell: BaseCell {
    
    var teamInfo: TeamInfo!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var newLabel: BaseLabel!
    @IBOutlet weak var teamInfoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
