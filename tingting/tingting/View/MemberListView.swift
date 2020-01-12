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
    
    var memberDriver: Driver<User> {
        return collectionView.rx.modelSelected(User.self).asDriver()
    }
    
    var items: BehaviorRelay<[User]> = .init(value: [])
    
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
        collectionView.delegate = self
        
        items.bind(to: collectionView.rx.items) { collectionView, index, user in
            let cell = collectionView.dequeueReusableBaseCell(type: MemberCell.self, for: .init(item: index, section: 0))
            cell.configure(with: user, isMaster: index == 0)
                
            return cell
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(User.self)
            .filter { _ in self.showMemberAuto }
            .observeOn(MainScheduler.asyncInstance)
            .bind { user in
                let viewController = UIApplication.shared.windows.last?.rootViewController
                let memberVC = MemberViewController.initiate(user: user)
                viewController?.present(memberVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func configure(with users: [User]) {
        items.accept(users)
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
        return CGSize(width: 85, height: 128)
    }
 }
 
