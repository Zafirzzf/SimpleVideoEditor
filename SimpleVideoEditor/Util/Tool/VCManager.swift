//
//  VCManager.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/7.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

class VCManager {
    
    // 最顶层的VC获取
    static func windowTopVC() -> UIViewController? {
        let rootVC = UIWindow.keyWindow.rootViewController
        guard let tabbarVC = rootVC as? UITabBarController else {
            return rootVC
        }
        let childNacVC = UIWindow.keyWindow.rootViewController?.children
        let selectedNavTab = childNacVC?[tabbarVC.selectedIndex] as? UINavigationController
        if let topVC = selectedNavTab?.topViewController {
            if topVC.presentedViewController != nil {
                return topVC.presentedViewController
            } else {
                return topVC
            }
        }
        
        return nil
    }
    
    /// 推出
    static func push(vc: UIViewController, animated: Bool = true) {
        guard let currentVC = windowTopVC() else { return }
        if let navi = currentVC as? UINavigationController {
            navi.pushViewController(vc, animated: animated)
        } else {
            currentVC.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    /// 弹出
    static func present(vc: UIViewController, animated: Bool = true) {
        guard let currentVC = windowTopVC() else { return }
        currentVC.present(vc, animated: animated, completion: nil)
    }
}
