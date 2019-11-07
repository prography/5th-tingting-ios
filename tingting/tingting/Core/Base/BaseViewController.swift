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

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
 
    private var cellHeightsDictionary: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.debug(className)
    }
    
    deinit {
        Logger.debug(className)
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
