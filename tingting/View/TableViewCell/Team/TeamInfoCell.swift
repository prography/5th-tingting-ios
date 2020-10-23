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
        let images = (1...4)
            .map { "sampleImage" + String($0) }
            .map { UIImage(named: $0) }
            .sorted { _, _ in Bool.random() }
            .sorted { _, _ in Bool.random() }
        
        imageViews.enumerated().forEach {
            $0.element.image = images[$0.offset]
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
