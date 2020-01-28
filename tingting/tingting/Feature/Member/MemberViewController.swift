//
//  MemberViewController.swift
//  tingting
//
//  Created by 김선우 on 12/22/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemberViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    
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
    
    override func bind() {
        reportButton.rx.tap.bind { [weak self] in

            let alert = UIAlertController(title: "해당 유저를 신고하시겠습니까?", message: "허위로 신고할 경우 서비스 이용의 불이익을 받을 수 있습니다.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let reportAction = UIAlertAction(title: "신고", style: .destructive) { _ in
                AlertManager.show(title: "신고가 처리되었습니다.")
                self?.reportButton.isHidden = true
            }

            alert.addAction(cancelAction)
            alert.addAction(reportAction)
            
            self?.present(alert, animated: true, completion: nil)
 
        }.disposed(by: disposeBag)
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


