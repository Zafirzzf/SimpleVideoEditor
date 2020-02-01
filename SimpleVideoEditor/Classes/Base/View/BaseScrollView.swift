//
//  BaseScrollView.swift
//  HappyBonus
//
//  Created by 周正飞 on 2019/1/8.
//  Copyright © 2019年 MIX. All rights reserved.
//

import UIKit

class BaseScrollView: UIScrollView {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init() {
        super.init(frame: .zero)
        addTap()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTap()
    }
    
    /// 通用的点击收回键盘方法
    func addTap() {
        
        whenTap { [unowned self] (tap) in
            tap.cancelsTouchesInView = false
            self.endEditing(true)
        }
    }
}
