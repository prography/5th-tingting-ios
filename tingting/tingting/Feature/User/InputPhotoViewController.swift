//
//  InputPhotoViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputPhotoViewController: BaseViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private let picker = UIImagePickerController()
    
    let isValid: BehaviorRelay<Bool> = .init(value: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.isHidden = false
        nextButton.setEnable(false)

        picker.delegate = self
        

        
    }
    
    override func bind() {
        inputButton.rx.tap.bind {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let actions = [
                UIAlertAction(title: "카메라", style: .default) { _ in
                    self.picker.sourceType = .camera
                    self.present(self.picker, animated: true)
                },
                UIAlertAction(title: "앨범", style: .default) { _ in
                    self.picker.sourceType = .photoLibrary
                    self.present(self.picker, animated: true)
                },
                UIAlertAction(title: "취소", style: .cancel)
            ]
            
            actions.forEach(actionSheet.addAction)
            
            
            if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
                if let popoverController = actionSheet.popoverPresentationController { // ActionSheet가 표현되는 위치를 저장해줍니다.
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                    self.present(actionSheet, animated: true, completion: nil)
                    
                }
            } else {
                self.present(actionSheet, animated: true, completion: nil)
            }
            
        }.disposed(by: disposeBag)
        
        isValid.bind(onNext: nextButton.setEnable)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(onNext: signUp)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setImage(to photo: UIImage?) {
        weak var photo = photo
        guard let image = photo else { nextButton.setEnable(false); return }
        photoImageView.image = image
        nextButton.setEnable(true)
        photoImageView.isHidden = false
    }
    
    func signUp() {
        let requset = ConnectionManager.shared.signUpRequest
        
        NetworkManager.signUp(request: requset).asObservable().subscribe(
            onNext: { [weak self] response in
                ConnectionManager.shared.saveToken(response.token)
//                AlertManager.show(title: response.message)
                self?.uploadThumbnailImage()
//                self?.close()
        },
            onError: { error in
                AlertManager.showError(error)
            }).disposed(by: disposeBag)
    }
    
}

extension InputPhotoViewController {
    func uploadThumbnailImage() {
        guard let image = photoImageView.image else {
            endLoading()
            close()
            return
            
        }
        
        NetworkManager.uploadThumbnailImage(image: image)
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
                    self?.close()
            }
        ).disposed(by: disposeBag)
    }
    
}
extension InputPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[.editedImage] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        photoImageView.image = newImage // 받아온 이미지를 이미지 뷰에 넣어준다.
        
        picker.dismiss(animated: true) // 그리고 picker를 닫아준다.
    }
}

extension InputPhotoViewController {
    static func initiate() -> InputPhotoViewController {
        
        let vc = InputPhotoViewController.withStoryboard(storyboard: .user)
        
        return vc
    }
}
