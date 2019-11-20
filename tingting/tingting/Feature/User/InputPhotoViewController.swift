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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.isHidden = false

        picker.delegate = self
        
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
            self.present(actionSheet, animated: true)
            
        }.disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setImage(to photo: UIImage?) {
        weak var photo = photo
        guard let image = photo else { return }
        photoImageView.image = image
        photoImageView.isHidden = false
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
