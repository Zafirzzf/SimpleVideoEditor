//
//  NSAttributedString.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit
infix operator +
extension NSAttributedString {
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let mutableAttributed = NSMutableAttributedString(attributedString: lhs)
        mutableAttributed.append(rhs)
        return mutableAttributed
    }
}

extension NSMutableAttributedString {
    static func +=(lhs: NSMutableAttributedString, rhs: NSAttributedString) {
        lhs.append(rhs)
    }
}

extension NSAttributedString {
    /// 增加行间距
    func addParagraphSpace(_ lineSpace: CGFloat) -> NSAttributedString {
        let attribute = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attribute.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.string.count))
        return attribute
    }
    
    /// 增加字体颜色格式
    func addAttribute(with font: UIFont, color: UIColor) -> NSAttributedString {
        let attribute = NSMutableAttributedString(attributedString: self)
        attribute.addAttributes([NSAttributedString.Key.font: font,
                                 NSAttributedString.Key.foregroundColor: color],
                                range: NSMakeRange(0, self.string.count))
        return attribute
    }
    
    /// 改变字体大小
    func changeFont(with font: UIFont) -> NSAttributedString {
        let attribute = NSMutableAttributedString(attributedString: self)
        attribute.addAttributes([NSAttributedString.Key.font: font], range: NSMakeRange(0, self.string.count))
        return attribute
    }
}

extension NSMutableAttributedString {
    /// 增加行间距
    func addMutableParagraphSpace(lineSpace: CGFloat) -> NSAttributedString {
        let attribute = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attribute.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.string.count))
        return attribute
    }
}
