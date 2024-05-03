//
//  CSJInsertAdManager.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/5/3.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation
import AHUIKitExtension
import BUAdSDK
import AHProgressView

final class CSJInsertAdManager: NSObject {
    
    static let shared = CSJManager()
    var ad: BUNativeExpressFullscreenVideoAd?
    private var currentSlotId: String?
    private var ads = insertSlotIds
    
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
            ads = insertSlotIds
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
            
            ad = BUNativeExpressFullscreenVideoAd(slotID: currentSlotId!)
            ad?.loadData()
            ad?.delegate = self
        }
    }
}

extension CSJInsertAdManager: BUNativeExpressFullscreenVideoAdDelegate {
    
    func nativeExpressFullscreenVideoAdDidDownLoadVideo(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        fullscreenVideoAd.show(fromRootViewController: .topViewController)
    }
    func nativeExpressFullscreenVideoAdViewRenderFail(_ rewardedVideoAd: BUNativeExpressFullscreenVideoAd, error: Error?) {
        if error == nil { return }
        AHProgressView.showTextToast(message: "广告位渲染失败:\n \(error?.localizedDescription ?? "")")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.loadAdData(isRetry: true)
        })
    }
    
    func nativeExpressFullscreenVideoAdDidPlayFinish(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        if error == nil { return }
        AHProgressView.showTextToast(message: "广告位渲染失败:\n \(error?.localizedDescription ?? "")")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.loadAdData(isRetry: true)
        })
    }
    
    func nativeExpressFullscreenVideoAd(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        let nsError = error as? NSError
        let errorCode = nsError?.code ?? -1
        let errorInfo = nsError?.userInfo
        AdLogWrapper.append(title: "广告位加载失败:\(String(describing: errorInfo)) + \(errorCode) + ", subTitle: error?.localizedDescription)
        AHProgressView.showTextToast(message: "广告位加载失败:\n \(error?.localizedDescription ?? "")")
        UIApplication.shared.isIdleTimerDisabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.loadAdData(isRetry: true)
        })
    }
}
