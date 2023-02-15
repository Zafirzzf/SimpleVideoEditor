//
//  GlobalSettings.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

/// 全局配置
class GlobalSettings {
        
    /// 版本号(每次上新版本更改)
    static let appVersionNum: Int = 2
    
    /// 当前版本号
    static var version: String {
        let info = Bundle.main.infoDictionary!
        guard let version = info["CFBundleShortVersionString"] as? String else { return ""}
        return version
    }    
}
