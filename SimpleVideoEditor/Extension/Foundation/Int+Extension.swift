//
//  Int+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var double: CGFloat {
        return CGFloat(self * 2)
    }
    
    var font: UIFont {
        return UIFont.regular(size: self.cg)
    }
    
    var fontMedium: UIFont {
        return UIFont.medium(size: self.cg)
    }
    
    var fontBold: UIFont {
        return UIFont.bold(size: self.cg)
    }
    
    /// 非负数
    var nonNegative: Int {
        var number = self
        if number < 0 {
            number = 0
        }
        return number
    }
    
    var isZero: Bool {
        return self == 0
    }
}

// MARK: - 类型转换
extension Int {
    var cg: CGFloat {
        return CGFloat(self)
    }
    var str: String {
        return String(self)
    }
}

// MARK: - 时间格式化
extension Int {
    /// 时间戳格式化为字符串
    func convertToTime(_ type: TimeFormatType) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formater = DateFormatter()
        switch type {
        case .ymd:
            formater.dateFormat = "yyyy-MM-dd"
        case .ymdhms:
            formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case .hms:
            formater.dateFormat = "HH:mm:ss"
        case .pointymd:
            formater.dateFormat = "yyyy.MM.dd"
        case .pointymdhms:
            formater.dateFormat = "yyyy.MM.dd HH:mm:ss"
        case .pointmdhms:
            formater.dateFormat = "MM月dd日 HH:mm:ss"
        case .md:
            formater.dateFormat = "MM月dd日"
        case .ym:
            formater.dateFormat = "yyyy-MM"
        case .md_line:
            formater.dateFormat = "MM-dd"
        case .hm:
            formater.dateFormat = "HH:mm"

            
        }
        return formater.string(from: date)
    }
}
enum TimeFormatType {
    /// 年-月-日
    case ymd
    /// 年-月-日 时:分:秒
    case ymdhms
    /// 时:分:秒
    case hms
    /// 年.月.日
    case pointymd
    /// 年.月.日 时.分.秒
    case pointymdhms
    /// -月-日  时-分-秒
    case pointmdhms
    /// -月-日
    case md
    ///年-月
    case ym
    ///月 - 日
    case md_line
    ///时：分
    case hm
    
}
