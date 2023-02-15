//
//  Decimal+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/5.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
extension Decimal {
    
    var number: NSDecimalNumber {
        return NSDecimalNumber(decimal: self)
    }
    
    var doubleValue: Double {
        return number.doubleValue
    }
    
    var stringValue: String {
        return number.stringValue
    }
}
