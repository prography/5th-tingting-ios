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
    
    func initiate() {
        
        let members = [0, 1, 2, 3].map { _ in Member() }
        
        collectionView.delegate = self
        
        Observable.just(members)
            .bind(to: collectionView.rx.items) { collectionView, index, element in
            let cell = collectionView.dequeueReusableBaseCell(type: MemberCell.self, for: .init(item: index, section: 0))
                
            return cell
        }.disposed(by: disposeBag)
        
       
        

    }
    
    override func commonInit() {
        super.commonInit()
        initiate()
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
 
