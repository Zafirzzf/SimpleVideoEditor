//
//  PreferenceConfig.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import SwiftyPreference
import AHLogRecorder

struct PreferenceConfig {
    @DefaultsKey(key: "openAppTimes", defaultValue: 0)
    static var openAppTimes: Int
    
    @DefaultsKey(key: "adRecordList", defaultValue: [])
    static var adRecordList: [LogRecorderDataSource.Recorder]
    
//    @DefaultsKey(key: "adAppId", defaultValue: nil)
//    static var adAppId: String?
//    
//    @DefaultsKey(key: "adShotIds", defaultValue: [])
//    static var adShotIds: [String]
    
    @DefaultsKey(key: "csjIsTestAd", defaultValue: false)
    static var csjIsTestAd: Bool
}
