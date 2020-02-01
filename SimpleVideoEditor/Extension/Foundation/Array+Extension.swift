//
//  Array+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/7.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

extension Array {
    /// 每个元素满足某一条件
    func allMatch(_ condition: @escaping (Element) -> Bool) -> Bool {
        for e in self {
            guard condition(e) else { return false }
        }
        return true
    }
    
    /// 对元素做某些变换后返回该数组
    func updateElement(_ transform: @escaping (Element) -> ()) -> [Element] {
        var result = [Element]()
        for e in self {
            transform(e)
            result.append(e)
        }
        return result
    }
    
    /// 删除满足条件的元素
    func deleteElement(_ condition: @escaping (Element) -> Bool) -> [Element] {
        var result = [Element]()
        for e in self {
            if !condition(e) {
                result.append(e)
            }
        }
        return result
    }
    
    /// 返回除了某一索引的数组
    func skipElement(of index: Int) -> [Element] {
        var result = [Element]()
        for (i, e) in self.enumerated() {
            if i != index {
                result.append(e)
            }
        }
        return result
    }
}

