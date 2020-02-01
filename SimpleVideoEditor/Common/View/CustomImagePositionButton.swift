//
//  CustomImagePositionButton.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/29.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class CustomImagePositionButton: UIButton {
    enum ImagePosition {
        case top, left, right, bottom
    }
    let position: ImagePosition
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    init(position: ImagePosition = .left, frame: CGRect = .zero) {
        self.position = position
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        switch position {
        case .left:
            break
        case .right:
            imageToRight()
        case .top:
            imageToTop()
        case .bottom:
            imageToBottom()
        }
    }
}

private extension UIButton {
    /// 调整图片在右
    func imageToRight() {
        guard let image = imageView?.image else { return }
        guard let label = titleLabel else { return }
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -image.size.width - 1, bottom: 0, right: image.size.width + 1)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: label.bounds.width + 1, bottom: 0, right: -label.bounds.width - 1)
    }
    /// 调整图片在上
    func imageToTop() {
        let imageHeight = imageView?.height ?? 0
        let imageWidth = imageView?.width ?? 0
        let titleHeight = titleLabel?.height ?? 0
        let titleWidth = titleLabel?.width ?? 0
        nb.imageEdgeInsets(-imageHeight.half + 10,
                           titleWidth.half,
                           imageHeight.half - 10,
                           -titleWidth.half)
            .titleEdgeInsets(titleHeight.half + 15,
                             -imageWidth.half,
                             -titleHeight.half - 15,
                             imageWidth.half)
    }
    /// 调整图片在下
    func imageToBottom() {
        let imageHeight = imageView?.height ?? 0
        let imageWidth = imageView?.width ?? 0
        let titleHeight = titleLabel?.height ?? 0
        let titleWidth = titleLabel?.width ?? 0
        nb.imageEdgeInsets(imageHeight.half - 10,
                           titleWidth.half,
                           -imageHeight.half + 10,
                           -titleWidth.half)
            .titleEdgeInsets(-titleHeight.half - 15,
                             -imageWidth.half,
                             titleHeight.half + 15,
                             imageWidth.half)
    }
}
