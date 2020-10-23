//
//  BaseViewController.swift
//  tingting
//
//  Created by 김선우 on 9/2/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
 
    private var cellHeightsDictionary: NSMutableDictionary = [:]
    
    let debugView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .default
        Logger.debug(className)
        DispatchQueue.main.async {
            self.bind()
        }
        
        view.addSubview(debugView)
        
//        debugView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDebugView()

    }
    
    func showDebugView() {
        view.bringSubviewToFront(debugView)
        debugView.isHidden = CURRENT_SERVER == .live
        debugView.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 50, width: 40, height: 40)
        // 커비
        //        let imageURL = "https://2.bp.blogspot.com/-4Yy6O1uwS5s/WDvli03Rp9I/AAAAAAALk3E/jxseZKbEGvIQIjRMcjJb3H-Rq3O9SOaTACLcB/s1600/AS001556_00.gif"
        // background png gif
        //        let imageURL = "https://i.pinimg.com/originals/79/d3/d2/79d3d23b69b77ccc0bd65dbdecf6501f.gif"
        // wow 아저씨
        // let imageURL = "https://media.giphy.com/media/12bSyZ2lLVvZ4s/giphy.gif"
        let imageURL = "https://1.bp.blogspot.com/-7h4dML_PiBI/WDvleupMDHI/AAAAAAALk2I/3BtJR5jYfLsBlsMZBCQY01FKEqyrgBenQCLcB/s1600/AS001555_08.gif"
        debugView.kf.setImage(with: URL(string: imageURL))
        //        debugView.alpha = 0.5
    }
    
    
    deinit {
        Logger.debug(className)
    }
    
    func bind() {
        
    }
 
    func close() {
        dismiss(animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func startLoading(backgroundColor: UIColor = .white) {
        
        view.isUserInteractionEnabled = false 
        
        DispatchQueue.main.async {
            IndicatorView.shared.show(parentView: self.view, backgroundColor: backgroundColor)
        }
    }
    
    func endLoading() {
        view.isUserInteractionEnabled = true
        IndicatorView.shared.hide()
    }
    
}

extension BaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
    }
    
    // recover height height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightsDictionary.object(forKey: indexPath) as? Double {
            return CGFloat(height)
        }
        return UITableView.automaticDimension
    }
}

extension BaseViewController {
    // Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
