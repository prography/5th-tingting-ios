//
//  TermsViewController.swift
//  tingting
//
//  Created by 김선우 on 2/2/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import M13Checkbox

class TermsViewController: UITableViewController {

    @IBOutlet weak var collegeButton: UIButton!
    
    @IBOutlet weak var agreeAllCheckbox: M13Checkbox!
    @IBOutlet weak var firstCheckbox: M13Checkbox!
    @IBOutlet weak var secondCheckbox: M13Checkbox!
    @IBOutlet weak var thirdCheckbox: M13Checkbox!
    
    @IBOutlet weak var firstTermButton: UIButton!
    @IBOutlet weak var secondTermButton: UIButton!
    @IBOutlet weak var thirdTermButton: UIButton!
    
    @IBOutlet weak var nextButton: BaseButton!
    
}

extension TermsViewController {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
