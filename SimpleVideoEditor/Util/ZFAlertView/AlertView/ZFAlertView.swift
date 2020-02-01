//
//  ZFAlertView.swift
//  ZFAlertView-Swift
//
//  Created by 周正飞 on 2018/3/13.
//  Copyright © 2018年 周正飞. All rights reserved.
//

import UIKit

class ZFAlertView: UIView {
    
    fileprivate let contentView = ZFAlertContent()
    
    init(title: String, leftTitle: String, rightTitle: String? = nil, isLeftClick: @escaping (Bool) -> Void) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let content = ZFAlertContent(title: title, leftTitle: leftTitle, rightTitle: rightTitle, isLeftClick: isLeftClick)
        addSubview(content)
    }
 
    func show() {
        guard let window = UIApplication.shared.delegate?.window! else {return}
        window.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
