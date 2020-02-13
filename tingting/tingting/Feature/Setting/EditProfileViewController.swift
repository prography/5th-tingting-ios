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
import Kingfisher

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var imageView: BaseImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var editButton: BaseButton!
    
    private let picker = UIImagePickerController()
    private var oldImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker(birthTextField)
        picker.delegate = self
        oldImage = imageView.image
    }
    
    override func bind() {
         
        imageButton.rx.tap.bind {
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
            self.present(actionSheet, animated: true)
            
        }.disposed(by: disposeBag)
        
        
        editButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                guard var user = ConnectionManager.shared.currentUser else { assertionFailure(); return }
                user.height = Int(self.heightTextField.text ?? "0")
                user.birth = self.birthTextField.text
                self.startLoading(backgroundColor: .clear)
                NetworkManager.editMyProfile(to: user).asObservable()
                    .subscribe(
                        onNext: { [weak self] response in
                            ConnectionManager.shared.currentUser = user
                            
                            if self?.oldImage == self?.imageView.image {
                                AlertManager.show(title: response.message)
                                self?.endLoading()
                            } else {
                                self?.uploadThumbnailImage()
                            }
                            
                    },
                        onError: { [weak self] error in
                            AlertManager.showError(error)
                            self?.endLoading()
                    }
                ).disposed(by: self.disposeBag)
                
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
        
        guard let user = ConnectionManager.shared.currentUser else { assertionFailure(); return }
        imageView.setImage(url: user.thumbnail)
        nicknameTextField.text = user.name ?? ""
        genderTextField.text = user.gender?.korean ?? ""
        birthTextField.text = user.birth ?? ""
        schoolTextField.text = user.schoolName ?? ""
        heightTextField.text = "\(user.height ?? -1)"
        
        nicknameTextField.isEnabled = false
        genderTextField.isEnabled = false
        schoolTextField.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


extension EditProfileViewController {
    @IBAction func setDatePicker(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }

    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    
}

extension EditProfileViewController {
    func uploadThumbnailImage() {
        guard let image = imageView.image else {
            endLoading()
            return }
        
        NetworkManager.uploadThumbnailImage(image: image)
            .asObservable()
            .subscribe(
                onNext: { [weak self] response in
                    
                    AlertManager.show(title: response.message)

                    KingfisherManager.shared.cache.clearMemoryCache()
                    KingfisherManager.shared.cache.clearDiskCache()
                    self?.endLoading()
                    self?.navigationController?.popToRootViewController(animated: true)
                },
                onError: { [weak self] error in
                    AlertManager.showError(error)
                    self?.endLoading()
            }
        ).disposed(by: disposeBag)
    }
    
}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[.editedImage] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        imageView.image = newImage // 받아온 이미지를 이미지 뷰에 넣어준다.
        
        picker.dismiss(animated: true) // 그리고 picker를 닫아준다.
    }
}
extension EditProfileViewController {
    static func initiate() -> EditProfileViewController {
        let vc = EditProfileViewController.withStoryboard(storyboard: .setting)
        return vc
    }
}

