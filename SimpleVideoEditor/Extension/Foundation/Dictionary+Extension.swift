//
//  Dictionary+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/10.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    /// 转换为Data
    func converToData() -> Data {
        guard JSONSerialization.isValidJSONObject(self) else {
            print("无法json序列化一个字典"); return Data()
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            print("字典无法转为好Data"); return Data()
        }
        return data
    }
}
