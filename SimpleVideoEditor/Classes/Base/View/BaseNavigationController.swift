//
//  BaseNavigationController.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit
import NimbleKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        modalPresentationStyle = .fullScreen
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.medium(size: 18)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController!.preferredStatusBarStyle
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backBtn = UIButton(type: .custom).nb
//                .image(Asset.Public.publicHeadBackBlack.image)
                .width(30).height(30)
                .imageEdgeInsets(0, -20, 0, 0)
                .base.addTouch { [unowned self] in
                    self.popViewController(animated: true)
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 手势代理
extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}

