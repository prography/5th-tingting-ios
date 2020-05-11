//
//  TeamTagViewController.swift
//  tingting
//
//  Created by 김선우 on 5/9/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TeamTagViewController: BaseViewController {
      
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTagButton: BaseButton!
    @IBOutlet weak var backgroundButton: UIButton!
    
    var selectedTag: [TeamTag] = []
    var didButtonPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        backgroundButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        
        addTagButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            guard (2...5).contains(self.selectedTag.count) else {
                AlertManager.showError("태그는 최소 2개, 최대 5개 입니다.")
                return
            }
            
            self.didButtonPressed = true
            self.dismiss(animated: true)
            
        }.disposed(by: disposeBag)
        
        
        collectionView.allowsMultipleSelection = true
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        Observable.just(tagList).bind(to: collectionView.rx.items(cellIdentifier: "cell")) { row, teamTag, cell in
            guard let tagCell = cell as? TagCell else { return }
            tagCell.tagLabel.text = "#" + teamTag.name
            
            if self.selectedTag.contains(teamTag) {
                tagCell.isSelected = true
                self.collectionView.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .init())
            }
              
            self.collectionView.allowsMultipleSelection = true
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(TeamTag.self).bind { teamTag in
            self.selectedTag.append(teamTag)
        }.disposed(by: disposeBag)

        collectionView.rx.modelDeselected(TeamTag.self).bind { teamTag in
            self.selectedTag.removeAll { $0 == teamTag }
        }.disposed(by: disposeBag)
        
//        collectionView.rx.itemSelected.bind { indexPath in
//            let teamTag = tagList[indexPath.row]
//            self.selectedTag.append(teamTag)
//        }.disposed(by: disposeBag)
//
//        collectionView.rx.itemDeselected.bind { indexPath in
//            let teamTag = tagList[indexPath.row]
//            self.selectedTag.removeAll { $0 == teamTag }
//        }.disposed(by: disposeBag)
        
    }
 
}

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        contentView.clipsToBounds = true
    }
     
    override var isSelected: Bool {
        didSet {
                self.setSelect()
        }
    }
    
    private func setSelect() {
        UIView.animate(withDuration: 0.15) {
            self.tagLabel.textColor = self.isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.5744549632, blue: 0.5127008557, alpha: 1)
            self.contentView.backgroundColor = self.isSelected ? #colorLiteral(red: 1, green: 0.5744549632, blue: 0.5127008557, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

extension TeamTagViewController {
    static func initiate() -> TeamTagViewController {
        let vc = TeamTagViewController.withStoryboard(storyboard: .team)
        return vc
    }
}
