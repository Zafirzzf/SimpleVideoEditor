//
//  UIWindow+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

extension UIWindow {
    static var keyWindow: UIWindow {
        if let defaultWindow = UIApplication.shared.keyWindow {
            return defaultWindow
        } else {
            debugLog("获取keywindow时发生错误,即将返回一个空window")
            return UIWindow()
        }
    }
}
