//
//  EditProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var imageView: BaseImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension EditProfileViewController {
    static func initiate() -> EditProfileViewController {
        let vc = EditProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}

