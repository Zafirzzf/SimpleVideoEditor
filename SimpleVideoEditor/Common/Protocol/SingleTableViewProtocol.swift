//
//  SingleTableViewProtocol.swift
//  SeekLightActor
//
//  Created by 周正飞 on 2019/11/6.
//  Copyright © 2019 周正飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SingleTableViewProtocol: AnyObject {
    associatedtype CellType: SingleTableViewCellProtocol
    var tableView: UITableView { get }
    var models: BehaviorRelay<[CellType.ModelType]?> { get }
    var disposeBag: DisposeBag { get }
    func selectTableViewCell(of indexPath: IndexPath, model: CellType.ModelType)
    func willUpdate(cell: CellType, data: CellType.ModelType, row: Int)
}

extension SingleTableViewProtocol {
    
    func registTableViewReloadObservable() {
        let cellID = CellType.description()
        tableView.register(CellType.self, forCellReuseIdentifier: cellID)
        models.map { $0 ?? []}.bind(to: tableView.rx.items(cellIdentifier: cellID, cellType: CellType.self)) { [weak self] row, data, cell in
            self?.willUpdate(cell: cell, data: data, row: row)
            cell.update(with: data)
        }.disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.selectTableViewCell(of: indexPath, model: self.models.value![indexPath.row])
        }).disposed(by: disposeBag)
    }
    
    func selectTableViewCell(of indexPath: IndexPath, model: CellType.ModelType) {
        
    }
    
    func willUpdate(cell: CellType, data: CellType.ModelType, row: Int) {
        
    }
}

protocol SingleTableViewCellProtocol where Self: UITableViewCell {
    associatedtype ModelType
    func update(with model: ModelType)
}
