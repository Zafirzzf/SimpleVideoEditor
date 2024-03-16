//
//  MusicItemCell.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/19.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class MusicItemCell: UITableViewCell, SingleTableViewCellProtocol {
    required init?(coder aDecoder: NSCoder) { nil }
    
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = 18.font
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        titleLabel.textColor = selected ? UIColor.subject : UIColor.white
    }
    
    func update(with model: MusicItem) {
        titleLabel.text = model.name
    }
    
}
