//
//  ZFSheetView.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/30.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

/// 底部弹出的选择框
class ZFSheetView: UIView {
    
    required init?(coder aDecoder: NSCoder) { return nil }

    private let contentView: ZFSheetContentView
    
    init(titles: [String], cancelTitle: String, itemClick: @escaping (Int) -> ()) {
        contentView = ZFSheetContentView(titles: titles, cancelTitle: cancelTitle, itemClick: itemClick)
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.white
        contentView.cancelClick = { [unowned self] in
            self.dismiss()
        }
        addSubview(contentView)
    }
    
    func show() {
        UIWindow.keyWindow.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = UIColor.blackLight.withAlphaComponent(0.5)
            self.contentView.y = self.height - TAB_IPHONEX_MARGIN - self.contentView.height
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.y = self.height
            self.backgroundColor = UIColor.blackLight.withAlphaComponent(0)

        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
}
