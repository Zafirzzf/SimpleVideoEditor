//
//  AdRecordLoger.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/3/31.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation
import AHLogRecorder

class AdLogWrapper {
    static let adLog = LogRecorderDataSource()

    static let shared = AdLogWrapper()
    
    private init() {
        PreferenceConfig.adRecordList.forEach {
            let title = $0.components(separatedBy: ",").first ?? ""
            let subTitle = $0.components(separatedBy: ",").last
            Self.adLog.append(title: title, subTitle: subTitle)
        }
    }
    
    static func append(title: String, subTitle: String? = nil) {
        adLog.append(title: title, subTitle: subTitle)
        var list = PreferenceConfig.adRecordList
        list.append(title + (subTitle.flatMap({ ", " + $0 }) ?? ""))
        PreferenceConfig.adRecordList = list
    }
    
    
}

