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
    static let blackBackground: [CGColor] = [UIColor.black.withAlphaComponent(0.7), UIColor.black.withAlphaComponent(0)].map { $0.cgColor }
    
}
