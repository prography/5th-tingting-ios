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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUser()
        guard let userID = user.id else { return }
        NetworkManager.getProfile(id: userID)
            .asObservable()
            .subscribe(
                onNext: { [weak self] profile in
                    self?.user = profile.userInfo
                    self?.loadUser()
                    
                },
                onError: { _ in
                    
            }
        ).disposed(by: disposeBag)
    }
    
}

extension MemberViewController {
    
    func loadUser() {
        imageView.setImage(url: user.thumbnail)
        nameAgeLabel.text = "\(user.name ?? ""), \(user.age)"
        
        if let height = user.height {
            heightLabel.text = "\(height)cm"
        } else {
            heightLabel.text = nil
        }
        
        schoolLabel.text = user.schoolName
        hobbyLabel.text = nil
    }
    
}

extension MemberViewController {
    static func initiate(user: User) -> MemberViewController {
        let vc = MemberViewController.withStoryboard(storyboard: .member)
        vc.user = user
        return vc
    }
}


