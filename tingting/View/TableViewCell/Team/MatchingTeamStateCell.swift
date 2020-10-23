//
//  MatchingTeamStateCell.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MatchingTeamStateCell: BaseCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
}
