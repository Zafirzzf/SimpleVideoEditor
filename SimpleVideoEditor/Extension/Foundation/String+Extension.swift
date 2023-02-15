//
//  String+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var international: String {
        NSLocalizedString(self, comment: self)
    }
    
    init?(json: [String: Any]) {
        if let jsonStr = (try? JSONSerialization.data(withJSONObject: json, options: []))
            .flatMap ({ String(data: $0, encoding: .utf8) }) {
            self = jsonStr
        } else {
            return nil
        }
    }

    func toImage() -> UIImage { UIImage(named: self)! }
}

// MARK: - 校验系列
extension String {
    /// 是否是数字类型
    var isNumberStr: Bool {
        return Double(self) != nil || self == "."
    }
    
    /// 不是空
    var notEmpty: Bool {
        return self.count > 0
    }
    
    /// 是否是手机号
    var isPhoneNumber: Bool {
        let mobileRegex = "^((1[3-9][0-9]))\\d{8}$"
        let mobileTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: self)
    }
}

extension String {
    
    var doubleValue: Double {
        guard self.isNumberStr else { return 0 }
        return Double(self) ?? 0
    }
    
    var intValue: Int {
        guard self.isNumberStr else { return 0 }
        return Int(self) ?? 0
    }
    /// 截取
    func subString(fromIndex: Int, toIndex: Int) -> String {
        let startIndex = self.startIndex
        let start = self.index(startIndex, offsetBy: fromIndex)
        let end = self.index(startIndex, offsetBy: toIndex)
        return String(self[start..<end])
    }
}

// MARK: - 富文本操作
extension String {
    /// 添加下划线
    var underLine: NSAttributedString {
        return NSMutableAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.underlineStyle: 1])
    }
    
    /// 增加行间距
    func addParagraphSpace(_ lineSpace: CGFloat) -> NSAttributedString {
        let attribute = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = .byCharWrapping
        attribute.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.count))
        return attribute
    }
    
    /// 转换为富文本
    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// 转为某字体颜色的富文本
    func attributeString(with font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color])
    }
    
    /// 字符串Size
    func size(of font: UIFont, width: CGFloat) -> CGSize {
        let attribute = NSAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.font: font])
        let size = attribute.boundingRect(with: CGSize(width: width, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size
    }
}

