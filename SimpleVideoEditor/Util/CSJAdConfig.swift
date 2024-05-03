//
//  CSJAdConfig.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/4/9.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation

var csjAppid: String { PreferenceConfig.csjIsTestAd ? "5519852" : "5519488" }

var insertSlotIds: [String] {
    ["957459806", "957459805", "957459803"]
}
var csjSlotIds: [String] { PreferenceConfig.csjIsTestAd ?
    ["956991985"] :
    ["956977004", "956976998", "956976988"]
}
