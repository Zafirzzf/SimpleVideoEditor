//
//  LoadNibable.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

protocol LoadNibable where Self: UIView  {
    
}

// MARK: - 快速加载Nib文件
extension LoadNibable {
    static func loadFromNib() -> Self {
        guard let view = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? Self else {
            return self.init()
        }
        return view
    }
}
extension UIView: LoadNibable { }
