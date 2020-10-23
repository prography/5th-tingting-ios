//
//  ApplyingMatchingTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 2/14/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ApplyingMatchingTeamViewController: BaseViewController {
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    var team: Team!
    var myTeamID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.text = ""
        messageTextView.tintColor = .primary
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNextButtonState(isEnable: false)
    }

    override func bind() {
        backgroundButton.rx.tap
            .bind { [weak self] in
                self?.close()
        }.disposed(by: disposeBag)
        
        messageTextView.rx.text
            .bind { [weak self] message in
                guard let message = message else { self?.setNextButtonState(isEnable: false); return }
                self?.placeholderLabel.isHidden = !message.isEmpty
                self?.descriptionLabel.text = "(\(message.count)/100)"
                switch message.count {
                case ...19:
                    self?.setNextButtonState(isEnable: false)
                case 20...100:
                    self?.setNextButtonState(isEnable: true)
                default:
                    self?.messageTextView.text = self?.messageTextView.text?[0..<100]
                    self?.setNextButtonState(isEnable: false)
                }
        }.disposed(by: disposeBag)
        
        sendButton.rx.tap.bind { [weak self] in
            self?.applyMatching()
        }.disposed(by: disposeBag)
    }

}

extension ApplyingMatchingTeamViewController {
    func setNextButtonState(isEnable: Bool) {
        sendButton.isUserInteractionEnabled = isEnable
        sendButton.titleLabel?.textColor = isEnable ? .primary : #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7843137255, alpha: 1)
    }
    func showMessageAlert() {
        AlertManager.show(title: "이거 대신 메세지 입력하는 거 나와야 함.")
        applyMatching()
        
    }
    
    func applyMatching() {
        
        startLoading(backgroundColor: .clear)
        var request = APIModel.ApplyMatching.Request()
        
        request.receiveTeamId = team.teamInfo.id
        request.sendTeamId = myTeamID
        request.message = messageTextView.text ?? ""
        
        NetworkManager.applyFirstMatching(request: request)
            .asObservable()
            .subscribe(
                onNext: { [weak self] response in
                    AlertManager.show(title: response.message)
                    self?.endLoading()
                    self?.close()
            },
                onError: { [weak self] error in
                    AlertManager.showError(error)
                    self?.endLoading()
            }
        ).disposed(by: disposeBag)
    }
}


extension ApplyingMatchingTeamViewController {
    static func initiate(team: Team, myTeamID: Int?) -> ApplyingMatchingTeamViewController {
        let vc = ApplyingMatchingTeamViewController.withStoryboard(storyboard: .matching)
        vc.team = team
        vc.myTeamID = myTeamID
        return vc
    }
}
