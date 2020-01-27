//
//  MyMatchingTeamCell+Configurator.swift
//  tingting
//
//  Created by 김선우 on 12/29/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
 
class MyMatchingTeamCellConfigurator<T: MyMatchingTeamCell>: CellConfigurator {
    var cellType: BaseCellProtocol.Type { T.self }
    let teamMatching: TeamMatching
    
    init(_ teamMatching: TeamMatching) {
        self.teamMatching = teamMatching
    }
    
    func configure(_ cell: BaseCellProtocol) {
        guard let cell = cell as? MyMatchingTeamCell else { return }
        
        let team = teamMatching.team()
        let users = team.teamMembers
        
        cell.imageViews.enumerated().forEach { index, imageView in
            let user = users[optional: index]
            imageView.isHidden = user == nil
            imageView.setImage(url: user?.thumbnail)
        }
        
        
    }
}

