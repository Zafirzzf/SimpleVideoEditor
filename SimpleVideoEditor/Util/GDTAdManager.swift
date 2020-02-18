//
//  GDTAdManager.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

class GDTAdManager: NSObject {
    static let shared = GDTAdManager()
    
    private let splashAd: GDTSplashAd
    
    override init() {
        splashAd = GDTSplashAd(appId: "1110246646", placementId: "4021007190959896")
        super.init()
        splashAd.delegate = self
        splashAd.fetchDelay = 5
        splashAd.backgroundImage = UIImage(color: UIColor.subject, size: UIScreen.main.bounds.size)
        
        let bottomView = BottomView(frame: [0, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.2, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2])
        self.splashAd.loadAndShow(in: UIWindow.keyWindow, withBottomView: bottomView)
    }
    
    func adShouldEnd() {
        UIWindow.keyWindow.rootViewController = PreSelectViewController()
    }
}

extension GDTAdManager: GDTSplashAdDelegate {
    func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        adShouldEnd()
    }
    
    func splashAdSuccessPresentScreen(_ splashAd: GDTSplashAd!) {
        print("成功展示")
    }
    
    func splashAdClosed(_ splashAd: GDTSplashAd!) {
        DispatchQueue.main.async {
            self.adShouldEnd()
        }
    }
    
    func splashAdExposured(_ splashAd: GDTSplashAd!) {
        print("成功曝光")
    }
    
    func splashAdDidDismissFullScreenModal(_ splashAd: GDTSplashAd!) {
        DispatchQueue.main.async {
            self.adShouldEnd()
        }
    }
}


private class BottomView: UIView {
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let logo = UIImageView(image: "icon".toImage())
            .nb.cornerRadius(8)
            .maskToBounds()
            .addToSuperView(self).base
                
        let titleLabel = UILabel().nb
            .font(UIFont(name: "Helvetica-BoldOblique", size: 22)!)
            .text("Simple Video")
            .textColor(UIColor.black)
            .addToSuperView(self).base
        
        logo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-70)
            $0.width.height.equalTo(60)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(logo.snp.right).offset(20)
            $0.centerY.equalToSuperview()
        }
        
    }
}
