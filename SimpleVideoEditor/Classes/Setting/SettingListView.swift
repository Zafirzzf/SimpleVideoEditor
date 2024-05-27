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
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.3, height: SCREEN_HEIGHT))
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.blackLight
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 50

        addSubview(tableView)
        registTableViewReloadObservable()

        let musicFileButton = OptionButton(position: .top)
            .nb.image("musicFile".toImage())
            .title("提取的音乐".international)
            .addToSuperView(self)
            .whenTap { [unowned self] in
                ZFAlertView(title: "解锁提取音乐", leftTitle: "取消", rightTitle: "看视频解锁") { isLeft in
                    if !isLeft {
                        GDTADManager.shared.loadAdData()
                    }
                }.show()
//                VCManager.push(vc: MusicFileViewController())
//                self.dismiss()
        }.base
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        musicFileButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
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
        $0.font = 18.fontMedium
        $0.textColor = UIColor.white.withAlphaComponent(0.8)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
        }
    }
    
    func update(with model: SettingItem) {
        titleLabel.text = model.title
    }
}
