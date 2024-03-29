//
//  UIColor+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    // 16进制颜色
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        // 0xFF0000
        guard hex.count >= 6 else {
            self.init()
            return
        }
        var upHex = hex.uppercased()
        if upHex.hasPrefix("0X") || upHex.hasPrefix("##") {
            upHex = (upHex as NSString).substring(from: 2)
        }
        if upHex.hasPrefix("#") {
            upHex = (upHex as NSString).substring(from: 1)
        }
        // 分别取出RGB
        var range = NSRange(location: 0, length: 2)
        let rHex = (upHex as NSString).substring(with: range) // FF
        range.location = 2
        let gHex = (upHex as NSString).substring(with: range) // 00
        range.location = 4
        let bHex = (upHex as NSString).substring(with: range) // 00
        var r: UInt32 = 0 , g: UInt32 = 0, b: UInt32 = 0
        
        /// Scanner,把16进制字符扫描成Int型
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r) , g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    
    static func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)) , g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)), alpha: 1.0)
    }
}
