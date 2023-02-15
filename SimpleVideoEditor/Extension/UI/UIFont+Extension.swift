//
//  UIFont+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFang-SC-Medium", size: size)!
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
}
