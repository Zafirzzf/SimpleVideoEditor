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
    private var loadAdFailCount = 0
    private var currentSlotId: String?
    private var failSlotIds: [String?] = []
    
    func initSDK(complete: @escaping () -> Void) {
        guard let appId = PreferenceConfig.adAppId else {
            DispatchQueue.main.async {
                UIViewController.topViewController.present(AdInfoInputVC(), animated: true)
            }
            return
        }
        
        let config = BUAdSDKConfiguration()
        config.appID = appId
        BUAdSDKManager.start(asyncCompletionHandler: { success, error in
            DispatchQueue.main.async {
                complete()
                AHProgressView.showTextToast(message: "穿山甲初始化结果: \(success), \(error)")
            }
        })
    }
    
    func loadAdData() {
        
        if PreferenceConfig.adAppId == nil {
            DispatchQueue.main.async {
                UIViewController.topViewController.present(AdInfoInputVC(), animated: true)
            }
            return
        }
        
        if currentSlotId == nil {
            currentSlotId = PreferenceConfig.adShotIds.randomElement()
        } else {
            currentSlotId = PreferenceConfig.adShotIds.filter {
                !failSlotIds.contains($0)
            }.randomElement()
        }
        if currentSlotId == nil {
            AHProgressView.showTextToast(message: "所有广告位尝试失败")
        }
        initSDK { [self] in
            let model = BURewardedVideoModel()
            model.rewardName = "钻石"
            model.rewardAmount = 200
            AHProgressView.loadingWithTimeout(4)
            
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
        adLog.append(title: "广告渲染成功\(currentSlotId!)")
        failSlotIds = []
    }
    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        adLog.append(title: "广告位加载失败:\(currentSlotId!)", subTitle: error?.localizedDescription)
        AHProgressView.showTextToast(message: "广告位加载失败:\n \(error?.localizedDescription ?? "")")
        failSlotIds.append(currentSlotId)
        loadAdData()
        print(#function, error)
        
    }
    
    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print(#function)
        ad?.show(fromRootViewController: .topViewController)
    }
}
