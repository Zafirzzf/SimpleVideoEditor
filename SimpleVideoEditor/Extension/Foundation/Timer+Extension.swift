//
//  Timer+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/12.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

extension Timer {
    /// 暂停
    func pause() {
        self.fireDate = Date.distantFuture
    }
    
    /// 继续
    func goOn() {
        self.fireDate = Date.distantPast
    }
}
