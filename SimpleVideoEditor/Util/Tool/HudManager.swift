//
//  HudManager.swift
//  MIX
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

private let KAfterDelay: TimeInterval = 2.0
class HudManager {
    
    static let shared = HudManager()
    private var hud = PKHUD.sharedHUD

    private init() {
        hud.userInteractionOnUnderlyingViewsEnabled = true
    }
    
    func showHud(interactionEnabled: Bool = true) {
        hud.userInteractionOnUnderlyingViewsEnabled = interactionEnabled
        hud.contentView = PKHUDSystemActivityIndicatorView()
        hud.show()
    }
    
    func dismissHud() {
        hud.hide()
    }
    
    func showSuccessHud(_ text: String) {
        hud.userInteractionOnUnderlyingViewsEnabled = true
//        let customView = PKHUDSquareBaseView(
//            image: Asset.Public.publicPopSuccess.image,
//            title: nil,
//            subtitle: text)
//        customView.frame.size = CGSize(width: 110, height: 110)
//        customView.backgroundColor = UIColor.blackLight.withAlphaComponent(0.8)
//        hud.contentView = customView
        hud.show()
        hud.hide(afterDelay: KAfterDelay)
    }
    
    func showFailure(_ text: String) {
        hud.userInteractionOnUnderlyingViewsEnabled = true
        showText(text)
    }
    
    //TODO
    func showText(_ text: String) {
        hud.userInteractionOnUnderlyingViewsEnabled = true
        let label = PKHUDTextView(text: text)
        hud.contentView = label
        hud.show()
        hud.hide(afterDelay: KAfterDelay)
    }
}
// MARK: - 子View的封装
extension HudManager {
    
//    var loadingView: UIView {
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 124, height: 124))
//        containerView.backgroundColor = UIColor.Common.blackLightLight
//        let animate = LOTAnimationView(name: "pullRefresh")
//        animate.size = CGSize(width: 70, height: 70)
//        animate.center = CGPoint(x: containerView.center.x, y: containerView.center.y - 10)
//        animate.loopAnimation = true
//        let msgLabel = UILabel(title: KeyString.s.loading, titleColor: UIColor.whiteAlpha_8, font: 16.font, backgroundColor: containerView.backgroundColor!)
//        msgLabel.size = CGSize(width: containerView.width, height: 20)
//        msgLabel.center.x = animate.center.x
//        msgLabel.y = animate.frame.maxY + 5
//        msgLabel.textAlignment = .center
//        containerView.addSubview(animate)
//        animate.play()
//        containerView.addSubview(msgLabel)
//        return containerView
//    }
}

