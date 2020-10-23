//
//  LabelCell.swift
//  tingting
//
//  Created by 김선우 on 12/28/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class LabelCell: BaseCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newLabel: BaseLabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LabelCell {
    
}
