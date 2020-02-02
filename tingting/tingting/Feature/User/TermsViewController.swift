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

class TermsViewController: BaseTableViewController {

    @IBOutlet weak var collegeButton: UIButton!
    
    @IBOutlet weak var agreeAllCheckbox: M13Checkbox!
    @IBOutlet weak var firstCheckbox: M13Checkbox!
    @IBOutlet weak var secondCheckbox: M13Checkbox!
    @IBOutlet weak var thirdCheckbox: M13Checkbox!
    
    @IBOutlet weak var firstTermButton: UIButton!
    @IBOutlet weak var secondTermButton: UIButton!
    @IBOutlet weak var thirdTermButton: UIButton!
    
    @IBOutlet weak var nextButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allCheckboxes = [agreeAllCheckbox, firstCheckbox, secondCheckbox, thirdCheckbox]
        
        allCheckboxes.forEach {
            $0?.stateChangeAnimation = .bounce(.fill)
            $0?.animationDuration = 0.1
        }
    }
    
    override func bind() {

        
        agreeAllCheckbox.stateDriver
            .driveNext { [weak self] state in
                
                self?.firstCheckbox.setCheckState(state, animated: true)
                self?.secondCheckbox.setCheckState(state, animated: true)
                self?.thirdCheckbox.setCheckState(state, animated: true)

                self?.nextButton.setEnable(state == .checked)
                
        }.disposed(by: disposeBag)
        
        let checkboxObservers = [firstCheckbox, secondCheckbox, thirdCheckbox]
            .compactMap { $0?.stateDriver.asObservable().share() }

        Observable.merge(checkboxObservers).bind { [weak self] _ in
            let stateList = [self?.firstCheckbox, self?.secondCheckbox,
                             self?.thirdCheckbox].compactMap { $0?.checkState }
            
            let isCheckAll = stateList.allSatisfy { $0 == .checked }
            self?.agreeAllCheckbox.setCheckState(isCheckAll ? .checked : .unchecked, animated: true)
            self?.nextButton.setEnable(isCheckAll)
            
        }.disposed(by: disposeBag)
        
        
    }
    
        
}
 
extension TermsViewController {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
 
