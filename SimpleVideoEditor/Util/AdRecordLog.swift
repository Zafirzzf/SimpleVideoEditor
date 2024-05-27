//
//  AdRecordLoger.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/3/31.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation
import AHLogRecorder
import ObjectMapper
import SwiftyPreference

extension LogRecorderDataSource.Recorder: Mappable, PreferenceModel {
    public init?(map: ObjectMapper.Map) {
        self.init(content: "", subContent: "")
    }
    
    public mutating func mapping(map: Map) {
        content <- map["content"]
        subContent <- map["subContent"]
        time <- map["time"]
    }
}
class AdLogWrapper {
    static let adLog = LogRecorderDataSource()

    static let shared = AdLogWrapper()
    
    private init() {
        Self.adLog.lists = PreferenceConfig.adRecordList
    }
    
    static func append(title: String, subTitle: String? = nil) {
        let recorder = LogRecorderDataSource.Recorder.init(content: title, subContent: subTitle)
        adLog.append(title: title, subTitle: subTitle)
        var list = PreferenceConfig.adRecordList
        list.append(recorder)
        PreferenceConfig.adRecordList = list
    }
    
    
}

