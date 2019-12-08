//
//  EmailAuthenticationViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit

class EmailAuthenticationViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
  
}

extension EmailAuthenticationViewController {
    static func initiate() -> EmailAuthenticationViewController {
        
        let vc = EmailAuthenticationViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
