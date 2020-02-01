//
//  TapScaleAnimation.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/29.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class ZoomButton: CustomImagePositionButton {
    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            guard newValue else { return }
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { _ in
                UIView.animate(withDuration: 0.15, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }
}
