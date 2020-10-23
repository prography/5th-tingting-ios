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
        
        // TODO: 네비바 말고 직접 버튼 구현 또는 투명도 조절
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func bind() {
        
        collegeButton.rx.tap.bind { [weak self] in
            // 4년제 대학 목록
            self?.showWebView("https://www.notion.so/ce7161a7928d4a04a5e3cee0f1690438")
        }.disposed(by: disposeBag)
 
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
            let stateList = [self?.firstCheckbox, self?.secondCheckbox, self?.thirdCheckbox]
                .compactMap { $0?.checkState }
            
            let isCheckAll = stateList.allSatisfy { $0 == .checked }
            self?.agreeAllCheckbox.setCheckState(isCheckAll ? .checked : .unchecked, animated: true)
            self?.nextButton.setEnable(isCheckAll)
            
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = EmailAuthenticationViewController.initiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        // 이용약관
        firstTermButton.rx.tap.bind { [weak self] in
            self?.showWebView("https://www.notion.so/bba04eeafbd144a7bd382b775c7c77f6")
        }.disposed(by: disposeBag)
        
        // 개인정보보호정책
        secondTermButton.rx.tap.bind { [weak self] in
            self?.showWebView("https://www.notion.so/4771f798cb0d43c4aa614bf3d5d1905d")
        }.disposed(by: disposeBag)

        // 자동 휴면 정책
        thirdTermButton.rx.tap.bind { [weak self] in
            self?.showWebView("https://www.notion.so/ecef8fb4c35747da818977d7126f35c8")
        }.disposed(by: disposeBag)
        
    }
        
}
 
extension TermsViewController {
    func showWebView(_ url: String) {

        let webVC = WebViewController.initiate(url: url)
        self.present(webVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
 

extension TermsViewController {
    static func initiate() -> TermsViewController {
        let vc = TermsViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
