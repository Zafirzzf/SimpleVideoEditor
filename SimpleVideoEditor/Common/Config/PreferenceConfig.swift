//
//  PreferenceConfig.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import SwiftyPreference

struct PreferenceConfig {
    @DefaultsKey(key: "openAppTimes", defaultValue: 0)
    static var openAppTimes: Int
    
    @DefaultsKey(key: "adRecordList", defaultValue: [])
    static var adRecordList: [String]
    
    @DefaultsKey(key: "adAppId", defaultValue: nil)
    static var adAppId: String?
    
    @DefaultsKey(key: "adShotIds", defaultValue: [])
    static var adShotIds: [String]
}
