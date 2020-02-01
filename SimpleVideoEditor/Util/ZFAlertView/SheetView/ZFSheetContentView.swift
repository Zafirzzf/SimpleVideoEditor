//
//  ZFSheetContentView.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/30.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

fileprivate let KItemHeight: CGFloat = 54

class ZFSheetContentView: UIView {
    
    required init?(coder aDecoder: NSCoder) { return nil }

    let titles: [String]
    let cancelTitle: String
    let itemClick: (Int) -> ()
    var cancelClick: (() -> ())?

    init(titles: [String], cancelTitle: String, itemClick: @escaping (Int) -> ()) {
        self.titles = titles
        self.cancelTitle = cancelTitle
        self.itemClick = itemClick
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.gray
        let cancelMargin: CGFloat = 10
        let lineHeight: CGFloat = 0.5
        let totalHeight = (titles.count + 1).cg * KItemHeight + (titles.count - 1).cg * lineHeight + cancelMargin
        
        for (i, title) in titles.enumerated() {
            let y  = (i.cg * lineHeight + KItemHeight) * i.cg
            let item = ZFSheetItem(frame: CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: KItemHeight))
            item.setTitle(title, for: .normal)
            item.addTouch { [unowned self] in
                self.itemClick(i)
                self.cancelClick?()
            }
            addSubview(item)
        }
        // 添加取消
        let cancel = ZFSheetItem(frame: CGRect(x: 0, y: totalHeight - KItemHeight, width: SCREEN_WIDTH, height: KItemHeight))
        cancel.setTitle(cancelTitle, for: .normal)
        cancel.addTouch { [unowned self] in
            self.cancelClick?()
        }
        addSubview(cancel)
        frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: totalHeight)
    }
}


class ZFSheetItem: UIButton {
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = 17.font
        setTitleColor(UIColor.gray, for: .normal)
        backgroundColor = .white
    }
}
