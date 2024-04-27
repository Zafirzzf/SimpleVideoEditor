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
    private var currentSlotId: String?
    private var ads = csjSlotIds
    
    func initSDK(complete: @escaping () -> Void) {

        let config = BUAdSDKConfiguration()
        config.appID = csjAppid
        BUAdSDKManager.start(asyncCompletionHandler: { success, error in
            DispatchQueue.main.async {
                complete()
            }
        })
    }
    
    func loadAdData(isRetry: Bool) {
        if !isRetry {
            // 如果不是重试 代码位数据重置
            ads = csjSlotIds
        }
        
        if ads.isEmpty {
            AHProgressView.showTextToast(message: "所有广告位尝试失败")
            return
        }
        currentSlotId = ads.removeFirst()
        initSDK { [self] in
            let model = BURewardedVideoModel()
            model.rewardName = "钻石"
            model.rewardAmount = 200
            AHProgressView.loading()
            UIApplication.shared.isIdleTimerDisabled = true
            ad = BUNativeExpressRewardedVideoAd(slotID: currentSlotId!, rewardedVideoModel: model)
            ad?.loadData()
            ad?.delegate = self
        }
        
    }
}

extension CSJManager: BUNativeExpressRewardedVideoAdDelegate {
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print(#function)
    }
    func nativeExpressRewardedVideoAdViewRenderSuccess(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        AHProgressView.hide()
        UIApplication.shared.isIdleTimerDisabled = false
        AdLogWrapper.append(title: "广告渲染成功\(currentSlotId!)")
        ads = csjSlotIds
    }
    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        let nsError = error as? NSError
        let errorCode = nsError?.code ?? -1
        let errorInfo = nsError?.userInfo
        AdLogWrapper.append(title: "广告位加载失败:\(String(describing: errorInfo)) + \(errorCode) + ", subTitle: error?.localizedDescription)
        AHProgressView.showTextToast(message: "广告位加载失败:\n \(error?.localizedDescription ?? "")")
        UIApplication.shared.isIdleTimerDisabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.loadAdData(isRetry: true)
        })
        print(#function, error)
        
    }
    
    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print(#function)
        ad?.show(fromRootViewController: .topViewController)
    }
}
