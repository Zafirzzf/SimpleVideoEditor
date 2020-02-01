//
//  Optional.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/30.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

extension Optional {
    
    func on(_ notNoneAction: (Wrapped) -> Void) {
        switch self {
        case .some(let value):
            notNoneAction(value)
        default:
            return
        }
    }
    // 不是nil
    var notNone: Bool {
        switch self {
        case .none:
            return false
        default:
            return true
        }
    }
    
    var isNone: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}
