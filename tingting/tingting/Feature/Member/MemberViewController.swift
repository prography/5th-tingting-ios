//
//  MemberViewController.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class MemberViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.setImage(url: user.thumbnail)
        nameAgeLabel.text = "\(user.name ?? ""), \(user.age)"
        
    }
    
}

extension MemberViewController {
    static func initiate(user: User) -> MemberViewController {
        let vc = MemberViewController.withStoryboard(storyboard: .member)
        vc.user = user
        return vc
    }
}


