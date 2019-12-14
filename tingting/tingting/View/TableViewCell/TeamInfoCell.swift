//
//  TeamInfoCell.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class TeamInfoCell: BaseCell {

    
    @IBOutlet var imageViews: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setStyle() {
        imageViews.forEach { image in
            image.layer.cornerRadius = image.frame.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
