//
//  BaseTableViewController.swift
//  tingting
//
//  Created by 김선우 on 2/2/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var cellHeightsDictionary: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .default
        Logger.debug(className)
        DispatchQueue.main.async {
            self.bind()
        }
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

extension BaseTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
    }
    
    // recover height height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightsDictionary.object(forKey: indexPath) as? Double {
            return CGFloat(height)
        }
        return UITableView.automaticDimension
    }
}

extension BaseTableViewController {
    
    // Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
