//
//  MyMatchingTeamCell.swift
//  tingting
//
//  Created by 김선우 on 12/28/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MyMatchingTeamCell: BaseCell {
    
    @IBOutlet var imageViews: [UIImageView]!
    
    @IBOutlet weak var chatAddressButton: BaseButton!
    @IBOutlet weak var rejectButton: BaseButton!
    @IBOutlet weak var applyButton: BaseButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
