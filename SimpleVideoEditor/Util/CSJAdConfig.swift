//
//  CSJAdConfig.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/4/9.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation

private let i1AppId = "5519488"
private let new1AppId = "5522153"
private let i1 = ["956977004", "956976998", "956976988"]
private let new1 = ["957061936", "957061935", "957061934"]


let csjAppid = PreferenceConfig.csjIsTestAd ? "5519852" : i1AppId
let csjSlotIds = PreferenceConfig.csjIsTestAd ?
["956991985"] : i1

