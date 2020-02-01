//
//  BaseTabBarController.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    /// 获取当前TabBar
    static var current: BaseTabBarController? {
        return UIWindow.keyWindow.rootViewController as? BaseTabBarController
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildVC()
        tabBar.isTranslucent = false
//        tabBar.tintColor = UIColor.black172233D
    }
    
    func setupChildVC() {

    }
}

extension UITabBarController {
    func addChildVC(_ vc: UIViewController, _ title: String , _ normalImage: UIImage?, _ selectedImage: UIImage?) {
        vc.tabBarItem.image = normalImage?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        let nav = BaseNavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        addChild(nav)
    }
}

