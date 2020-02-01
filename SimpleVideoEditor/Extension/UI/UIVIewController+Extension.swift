//
//  UIVIewController+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2019/1/9.
//  Copyright © 2019年 MIX. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var baseNaviContained: BaseNavigationController {
        return BaseNavigationController(rootViewController: self)
    }
    
    var isNaviRoot: Bool {
        guard let nav = navigationController else { return true }
        return nav.children.count == 1 
    }
}
