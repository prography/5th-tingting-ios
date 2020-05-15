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
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 158, height: 80)
            flowLayout.minimumInteritemSpacing = 12 // line
            flowLayout.minimumLineSpacing = 10 // width
            collectionView.collectionViewLayout = flowLayout
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
 
            collectionView.register(MemberCell.self)
        }
    }
    
    override func bind() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
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
 
 extension MemberListView: UICollectionViewDelegateFlowLayout {
 
 }
 
