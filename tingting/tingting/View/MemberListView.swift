//
//  MemberListView.swift
//  tingting
//
//  Created by 김선우 on 12/8/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa 

class MemberListView: BaseView {

    var showMemberAuto = true
    
    var memberDriver: Driver<Member> {
        return collectionView.rx.modelSelected(Member.self).asDriver()
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 190)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 0.0
            collectionView.collectionViewLayout = flowLayout
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            
            collectionView.register(MemberCell.self)
        }
    }
    
    override func bind() {
        
        let members = [0, 1, 2, 3].map { _ in Member() }
        
        collectionView.delegate = self
        
        Observable.just(members)
            .bind(to: collectionView.rx.items) { collectionView, index, element in
            let cell = collectionView.dequeueReusableBaseCell(type: MemberCell.self, for: .init(item: index, section: 0))
                
                cell.layer.cornerRadius = 10
                cell.layer.borderColor = .primary
                cell.layer.borderWidth = 2
                
            return cell
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Member.self)
            .filter { _ in self.showMemberAuto }
            .observeOn(MainScheduler.asyncInstance)
            .bind { member in
                let viewController = UIApplication.shared.windows.last?.rootViewController
                let memberVC = MemberViewController.initiate()
                viewController?.present(memberVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func commonInit() {
        super.commonInit()
    }

}
 
 extension MemberListView: UICollectionViewDelegate {
 
 }

 extension MemberListView: UICollectionViewDelegateFlowLayout {
    
    // MARK: Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 100)
    }
 }
 
