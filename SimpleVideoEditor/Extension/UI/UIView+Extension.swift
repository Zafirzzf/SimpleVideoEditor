//
//  UIView+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
    func isDisplayInScreen() -> Bool {
        let screenRect = UIScreen.main.bounds
        guard self.view.window != nil else { return false}
        guard self.view.superview != nil else { return false }
        guard let _ = UIApplication.shared.keyWindow else {return false}
        let rect = self.view.convert(self.view.frame, from: nil)
        if rect.isEmpty || rect.isNull {
            return false
        }
        
        return rect.intersects(screenRect)
    }
}
extension UIView {
    /// 获取当前view是否显示在屏幕上
    func isDisplayInScreen() -> Bool {
        let screenRect = UIScreen.main.bounds
        guard self.window != nil else { return false}
        guard self.superview != nil else { return false }
        guard let _ = UIApplication.shared.keyWindow else {return false}
        let rect = self.convert(frame, from: nil)
        if rect.isEmpty || rect.isNull {
            return false
        }
        
        return rect.intersects(screenRect)
    }
}

// MARK: - 坐标相关
extension UIView {
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    var centerX:CGFloat{
        set{
            self.center = CGPoint(x:newValue, y:self.center.y)
        }
        get{
            return self.center.x
        }
    }
    
    var centerY:CGFloat{
        set{
            self.center = CGPoint(x:self.center.x, y:newValue)
        }
        get{
            return self.center.y
        }
    }
    
    var maxY: CGFloat {
        return y + height
    }
    
    var maxX: CGFloat {
        return x + width
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
}

// MARK: - 加入渐变色
extension UIView {
    
    func removeGradientLayer() {
        guard let gradientLayers = self.layer.sublayers?.filter({$0 is CAGradientLayer}) as? [CAGradientLayer] else {
            return
        }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    enum GradientDirection {
        case left
        case right
        case bottom
        case top
    }
    /// 添加某颜色的渐变色
    func addGradientLayer(with colors: [CGColor], direction: GradientDirection) {
        
        func addLayer() {
            let startPoint: CGPoint
            let endPoint: CGPoint
            switch direction {
            case .left:
                startPoint = CGPoint.zero
                endPoint = CGPoint(x: 1, y: 0)
            case .right:
                startPoint = CGPoint(x: 1, y: 0)
                endPoint = CGPoint.zero
            case .bottom:
                startPoint = CGPoint(x: 0, y: 1)
                endPoint = CGPoint.zero
            case .top:
                startPoint = CGPoint.zero
                endPoint = CGPoint(x: 0, y: 1)
            }
            let layer = CAGradientLayer()
            layer.frame = self.bounds
            layer.colors = colors
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            self.layer.insertSublayer(layer, at: 0)
        }
        guard let gradientLayers = self.layer.sublayers?.filter({$0 is CAGradientLayer}) as? [CAGradientLayer] else {
            addLayer()
            return
        }
        if gradientLayers.count > 0 {
            gradientLayers.first?.colors = colors
        } else {
            addLayer()
        }
    }
}

// MARK: - 切圆角
extension UIView {
    /// 添加指定位置圆角
    func addRoundedCorners(direction: UIRectCorner,
                           cornerRadii: CGSize) {
        let targetRect = self.bounds
        let rouned = UIBezierPath(roundedRect: targetRect, byRoundingCorners: direction, cornerRadii: cornerRadii)
        let shape = CAShapeLayer()
        shape.path = rouned.cgPath
        self.layer.mask = shape
    }
}
