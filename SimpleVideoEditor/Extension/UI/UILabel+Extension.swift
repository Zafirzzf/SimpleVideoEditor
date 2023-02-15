//
//  UILabel+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/30.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UILabel {
    
    /// 根据内容调整宽度
    func adjustWidthByContent() {
        let attribute = NSAttributedString(
            string: self.text!,
            attributes: [NSAttributedString.Key.font: self.font])
        let targetWidth = attribute.boundingRect(with: CGSize(width: 1000, height: 1000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width
        self.width = targetWidth
    }
    
    /// 内容的Size
    var textSize: CGSize {
        guard let content = self.text else { return CGSize.zero }
        let attribute = NSAttributedString(
            string: self.text!,
            attributes: [NSAttributedString.Key.font: self.font])
        let size = attribute.boundingRect(with: CGSize(width: 1000, height: 1000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size
    }
}

extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        return Binder.init(self.base, binding: { (label, color) in
            label.textColor = color
        })
    }
}
