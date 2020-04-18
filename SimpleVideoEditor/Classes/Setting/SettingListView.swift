//
//  SettingListView.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingListView: UIView, SingleTableViewProtocol, SideSheetProtocol {
    
    typealias CellType = SettingItemCell
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    let tableView = UITableView()
    var models: BehaviorRelay<[SettingItem]?> = .init(value: SettingItem.items)
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.4, height: SCREEN_HEIGHT))
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.blackLight
        let titleLabel = UILabel().nb.font(18.fontBold)
            .text("我的设置".international)
            .textColor(UIColor.white)
            .addToSuperView(self).base
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        addSubview(tableView)
        registTableViewReloadObservable()
        
        let textLogo = TextLogoLabel()
            .nb.textColor(UIColor.white.withAlphaComponent(0.8))
            .backgroundColor(.clear)
            .textAlignment(.center)
            .addToSuperView(self).base
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.left.equalTo(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.equalTo(titleLabel)
            $0.centerX.width.equalToSuperview()
        }
        textLogo.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(SCREEN_HEIGHT * 0.1)
        }
    }
    
    func selectTableViewCell(of indexPath: IndexPath, model: SettingItem) {
        model.action()
        dismiss()
    }
}

class SettingItemCell: UITableViewCell, SingleTableViewCellProtocol {
    
    typealias ModelType = SettingItem
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    private let titleLabel = UILabel().then {
        $0.font = 15.fontMedium
        $0.textColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
        }
    }
    
    func update(with model: SettingItem) {
        titleLabel.text = model.title
    }
}
