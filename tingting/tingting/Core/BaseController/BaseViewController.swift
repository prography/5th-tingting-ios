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
    
    let debugView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .default
        Logger.debug(className)
        DispatchQueue.main.async {
            self.bind()
        }
        
        view.addSubview(debugView)
        
        debugView.textAlignment = .center
        debugView.text = "dev server"
        debugView.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        debugView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.1161440497)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(debugView)
        
        debugView.isHidden = CURRENT_SERVER == .live
        debugView.frame = CGRect(x: 0, y: self.view.frame.size.height - 30, width: self.view.frame.size.width, height: 30)
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
