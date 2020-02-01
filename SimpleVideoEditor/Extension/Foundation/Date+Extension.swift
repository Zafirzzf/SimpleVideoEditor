//
//  Date+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

extension Date {
    /// 当前时间
    static var BeiJingDateInterval: Int {
        // 东八区时间
        return Int(Date().timeIntervalSince1970) + 8 * 60 * 60
    }
    
    static var BeiJingDate: Date {
        Date(timeIntervalSince1970: TimeInterval(BeiJingDateInterval))
    }
    
    /// 明天
    var tommrow: Date {
        return Date(timeIntervalSince1970: TimeInterval(int + 24 * 60 * 60))
    }
    
    var int: Int {
        return Int(self.timeIntervalSince1970)
    }
}
