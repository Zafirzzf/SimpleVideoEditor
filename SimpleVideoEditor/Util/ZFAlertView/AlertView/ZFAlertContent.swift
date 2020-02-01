 //
//  ZFAlertContent.swift
//  ZFAlertView-Swift
//
//  Created by 周正飞 on 2018/3/13.
//  Copyright © 2018年 周正飞. All rights reserved.
//

import UIKit
fileprivate let lineHeight = 1 / UIScreen.main.scale
class ZFAlertContent: UIView {

    fileprivate var title: String = ""
    fileprivate var leftTitle: String = ""
    fileprivate var rightTitle: String?
    fileprivate var isLeftClick: ((Bool) -> Void)!
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    
    init(title: String, leftTitle: String, rightTitle: String? = nil, isLeftClick: @escaping (Bool) -> Void) {
        super.init(frame: CGRect(x: 47, y: 0, width: UIScreen.main.bounds.width - 47 * 2, height: 154))
        self.centerY = SCREEN_HEIGHT.half
        self.title = title
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.isLeftClick = isLeftClick
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func leftButtonClick() {
        isLeftClick(true)
        superview?.removeFromSuperview()
    }
    
    @objc func rightButtonClick() {
        isLeftClick(false)
        superview?.removeFromSuperview()
    }
    
    func setupView() {
//        backgroundColor = UIColor.Common.grayCCCCCC
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero,
                                               size: CGSize(width: bounds.width,
                                                            height: bounds.height - 50 - lineHeight)))
        titleLabel.backgroundColor = UIColor.white
//        titleLabel.textColor = UIColor.Common.black333333
        titleLabel.font = 18.font
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = title
        addSubview(titleLabel)
        
        if rightTitle == nil { // 一个按钮
   
        } else {
            let leftBtn = UIButton(frame: CGRect(x: 0, y: titleLabel.frame.maxY + lineHeight, width: (bounds.width / 2 - lineHeight), height: 50))
            leftBtn.setTitle(leftTitle, for: .normal)
//            leftBtn.setTitleColor(UIColor.Common.subject, for: .normal)
            buttonCommonProperty(leftBtn)
            leftBtn.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
            addSubview(leftBtn)
            
            let rightBtn = UIButton(frame: CGRect(x: leftBtn.frame.maxX + lineHeight, y: leftBtn.frame.minY, width: leftBtn.bounds.width, height: leftBtn.bounds.height))
            rightBtn.setTitle(rightTitle, for: .normal)
//            rightBtn.setTitleColor(UIColor.Common.subject, for: .normal)
            buttonCommonProperty(rightBtn)
            rightBtn.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
            addSubview(rightBtn)
        }
    }
    
    func buttonCommonProperty(_ button: UIButton) {
        button.titleLabel?.font = 18.font
        button.titleLabel?.textAlignment = .center
//        let highLightedColor = UIColor.Common.grayCCCCCC
//        button.setBackgroundImage(UIImage(color: highLightedColor), for: .highlighted)
        button.setBackgroundImage(UIImage(color: UIColor.white), for: .normal)
    }
}
 
extension UIImage {
    public convenience init(color: UIColor) {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
 }








