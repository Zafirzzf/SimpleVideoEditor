//
//  UIButton+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

extension UIButton {
    private struct AssociateKeys {
        static var buttonTouch = "buttonTouch"
    }
    
    typealias TouchedClosure = () -> Void
    /// 快速添加事件
    @discardableResult func addTouch(closure: @escaping TouchedClosure) -> UIButton{
        objc_setAssociatedObject(self, &AssociateKeys.buttonTouch, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(touchClick), for: .touchUpInside)
        return self
    }
    
    @objc private func touchClick() {
        if let closure = objc_getAssociatedObject(self,&AssociateKeys.buttonTouch) as? UIButton.TouchedClosure{
            closure()
        }
    }
}
