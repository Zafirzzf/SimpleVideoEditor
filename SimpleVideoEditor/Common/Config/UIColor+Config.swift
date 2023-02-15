//
//  UIColor+Config.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

extension UIColor {
    static let subject = UIColor("#FF6685")
    static let blackLight = UIColor("#191F2E")
    static let confirmGradientColors = [UIColor("#FF4466"), UIColor("#FF809A")]
    static let blackBackground: [CGColor] = [UIColor.blackLight.withAlphaComponent(0.7), UIColor.blackLight.withAlphaComponent(0)].map { $0.cgColor }
    
}
