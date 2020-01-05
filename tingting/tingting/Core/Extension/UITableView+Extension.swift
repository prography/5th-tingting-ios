//
//  UITableView+Extension.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    open func register<T: UITableViewCell>(_ cell: T.Type) {
        let className = cell.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func dequeueReusableBaseCell<T: BaseCellProtocol>(type: T.Type) -> BaseCell {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier) as? BaseCell
            else { fatalError("BaseCell must exist.") }
        cell.disposeBag = DisposeBag()
        
        return cell
    }
    
    func dequeueReusableBaseCell(with identifier: String) -> BaseCell {
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? BaseCell
            else { fatalError("BaseCell must exist.") }
        return cell
    }
    
    func dequeueReusableBaseCell(by configurator: CellConfigurator) -> BaseCell {
        let identifier = configurator.cellType.identifier
        let cell = dequeueReusableBaseCell(with: identifier)
        cell.disposeBag = DisposeBag()
        return cell
    }
    
    func configuredBaseCell(with configurator: CellConfigurator) -> BaseCell {
        let identifier = configurator.cellType.identifier
        let cell = dequeueReusableBaseCell(with: identifier)
        cell.disposeBag = DisposeBag()
        configurator.configure(cell)
        return cell
    }
}

extension UITableView {
    func didSetDefault() {
        
        self.register(MatchingTeamStateCell.self)
        self.register(MyMatchingTeamCell.self)
        self.register(MyTeamCell.self)
        self.register(TeamInfoCell.self)
        self.register(LabelCell.self)
        self.register(JoinTeamCell.self)
        self.register(SpaceCell.self)
        
        
        self.separatorStyle = .none
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
    }
}
