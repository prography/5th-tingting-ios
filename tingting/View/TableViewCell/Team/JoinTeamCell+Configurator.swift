//
//  JoinTeamCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/31/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//
 
import UIKit
import Kingfisher

class JoinTeamCellConfigurator<T: JoinTeamCell>: CellConfigurator {
    
    let team: Team
    
    var cellType: BaseCellProtocol.Type { T.self }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let cell = cell as? JoinTeamCell else { return }
        
        cell.teamNameLabel.text = team.teamInfo.name ?? ""
        cell.placeLabel.text = team.teamInfo.place ?? ""
        cell.imageViews.enumerated()
            .forEach { index, imageView in
                guard
                    let member = self.team.teamMembers[optional: index] else {
                    imageView.isHidden = true
                    return
                }

                imageView.isHidden = false
                
                guard let thumbnail = member.thumbnail else {
                    imageView.image = nil
                    imageView.backgroundColor = .gray
                    return
                }
                
                // TODO: Add Placeholder Image
                imageView.setImage(url: thumbnail)
                
                
        }
        
    }
    
    init(team: Team) {
        self.team = team
    }
  
}


