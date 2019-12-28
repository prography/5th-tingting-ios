//
//  InputProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputProfileViewController: BaseViewController {

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        nextButton.rx.tap.bind {
            let photoVC = InputPhotoViewController.initiate()
            self.navigationController?.pushViewController(photoVC, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension InputProfileViewController {
    static func initiate() -> InputProfileViewController {
        let vc = InputProfileViewController.withStoryboard(storyboard: .user)
        return vc
    }
}
