//
//  GDTADManager.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/5/27.
//  Copyright © 2024 周正飞. All rights reserved.
//

import Foundation
import AHProgressView

class GDTADManager: NSObject {
    
    static let shared = GDTADManager()
    
    var rewardVideo: GDTRewardVideoAd?
    
    override init() {
        super.init()
        let initResult = GDTSDKConfig.initWithAppId("1206910855")
        
        if !initResult {
            assertionFailure()
        }
    }
    
    private func initSDK(complete: @escaping () -> Void) {
        _ = GDTADManager.shared
        GDTSDKConfig.start { success, error in
            if success {
                complete()
            } else {
                assert(success)
            }
        }
    }
    
    func loadAdData() {
        initSDK { [self] in
            rewardVideo = GDTRewardVideoAd.init(placementId: "7069560445173044")
            rewardVideo?.delegate = self
            AHProgressView.loading()
            rewardVideo?.load()
        }
    }
}

// MARK: 代理
extension GDTADManager: GDTRewardedVideoAdDelegate {
    func gdt_rewardVideoAdVideoDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        AHProgressView.hide()
        guard let rewardVideo, rewardVideo.isAdValid else {
            AHProgressView.showTextToast(message: "广告加载失败")
            AdLogWrapper.append(title: "广告加载失败: 过期了")
            return
        }
        rewardVideo.show(fromRootViewController: .topViewController)
    }
    
    func gdt_rewardVideoAdDidRewardEffective(_ rewardedVideoAd: GDTRewardVideoAd, info: [AnyHashable : Any]) {
        AdLogWrapper.append(title: "广告渲染成功: 价格\(String(describing: rewardedVideoAd.eCPM() / 10))毛")
    }
    
    func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: any Error) {
        AHProgressView.hide()
        AdLogWrapper.append(title: "广告加载失败: \(error)")

    }
}
