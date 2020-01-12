//
//  CreateTeamViewController.swift
//  tingting
//
//  Created by 김선우 on 11/14/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import WSTagsField

class CreateTeamViewController: BaseViewController {

    @IBOutlet weak var tagsView: UIView!
    
    fileprivate let tagsField = WSTagsField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTagsField()
    }
    
    func setTagsField() {
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)

        //tagsField.translatesAutoresizingMaskIntoConstraints = false
        //tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true

        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10

        
        //tagsField.numberOfLines = 3
        //tagsField.maxHeight = 100.0

        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding

        tagsField.placeholder = "태그를 입력하세요.."
        tagsField.placeholderColor = .lightGray
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = #colorLiteral(red: 0.9719446301, green: 0.9719673991, blue: 0.9719551206, alpha: 1)
        tagsField.tintColor = .primary
        tagsField.returnKeyType = .continue
        tagsField.delimiter = ""
        
        

        tagsField.textDelegate = self

        textFieldEvents()
    }
}
 
extension CreateTeamViewController {

    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }

        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }

}

extension CreateTeamViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
//            anotherField.becomeFirstResponder()
        }
        return true
    }

}

extension CreateTeamViewController {
    static func initiate() -> CreateTeamViewController {
        let vc = CreateTeamViewController.withStoryboard(storyboard: .team)
        
        return vc
    }
}
