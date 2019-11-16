//
//  InputProfileViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class InputProfileViewController: BaseViewController {

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
 

}
