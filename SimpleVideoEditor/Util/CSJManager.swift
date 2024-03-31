//
//  CSJManager.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/3/24.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation
import AHUIKitExtension
import BUAdSDK
import AHProgressView

final class CSJManager: NSObject {
    
    static let shared = CSJManager()
    var ad: BUNativeExpressRewardedVideoAd?
    
    private override init() {
        
        super.init()
        let config = BUAdSDKConfiguration()
        config.appID = "5512536"
        BUAdSDKManager.start(asyncCompletionHandler: { success, error in
            print("穿山甲初始化结果: \(success), \(error)")
        })
       
    }
    
    func loadAdData() {
        let model = BURewardedVideoModel()
        model.rewardName = "钻石"
        model.rewardAmount = 200

        ad = BUNativeExpressRewardedVideoAd(slotID: "956692499", rewardedVideoModel: model)
        ad?.loadData()
        ad?.delegate = self

    }
}

extension CSJManager: BUNativeExpressRewardedVideoAdDelegate {
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print(#function)
    }
    func nativeExpressRewardedVideoAdViewRenderSuccess(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        adLog.append(title: "广告渲染成功")
    }
    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        adLog.append(title: "广告加载失败", subTitle: error?.localizedDescription)
        AHProgressView.showTextToast(message: "广告加载失败:\n \(error?.localizedDescription ?? "")")
        print(#function, error)
    }
    
    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print(#function)
        ad?.show(fromRootViewController: .topViewController)
    }
}
