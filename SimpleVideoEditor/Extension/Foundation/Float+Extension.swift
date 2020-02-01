//
//  Float+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit

infix operator **
extension Double {
    
    var cg: CGFloat {
        return CGFloat(self)
    }
    
    var decimalValue: Decimal {
        return Decimal(self)
    }
    
    // 是负数
    var isNegative: Bool {
        return self < 0
    }
    
    static func **(lhs: Double, rhs: Double) -> Double {
        return (lhs.decimalValue * rhs.decimalValue).doubleValue
    }
    
    var stringValue: String {
        let formmater = NumberFormatter()
        formmater.minimumFractionDigits = 0
        formmater.maximumFractionDigits = 8
        var resultStr = formmater.string(from: NSNumber(value: self))!
        if resultStr.first == "." {
            resultStr.insert("0", at: resultStr.startIndex)
        }
        return resultStr
    }
    
    var intValue: Int {
        return Int(self)
    }
    
    /// 保留几位小数(五不入)
    func stringValue(of place: Int) -> String {
        let formmater = NumberFormatter()
        formmater.minimumFractionDigits = place
        formmater.maximumFractionDigits = place
        var resultStr = formmater.string(from: NSNumber(value: self.decimalToPrice(with: place)))!
        if resultStr.first == "." {
            resultStr.insert("0", at: resultStr.startIndex)
        }
        if resultStr.first == "-" , resultStr.count > 2 , resultStr[resultStr.index(resultStr.startIndex, offsetBy: 1)] == "." {
            resultStr.insert("0", at: resultStr.index(after: resultStr.startIndex))
        }
        return resultStr
    }
    
    /// 转换为几位小数(不四舍五入)
    func decimalToPrice(with decimalPlace: Int) -> Double {
        let result = floor(self * pow(10, Double(decimalPlace))) / pow(10, Double(decimalPlace))
        return result
    }
    
    /// 用逗号分割的
    func stringIntervalValue(of place: Int) -> String {
        let format = NumberFormatter()
        //设置numberStyle（有多种格式）
        format.usesGroupingSeparator = true
        format.groupingSize = 3
        format.groupingSeparator = ","
        format.minimumFractionDigits = place
        //转换后的string
        format.maximumFractionDigits = 8
        var resultStr = format.string(from: NSNumber(value: self))!
        if resultStr.first == "." {
            resultStr.insert("0", at: resultStr.startIndex)
        }
        return resultStr
    }
}
