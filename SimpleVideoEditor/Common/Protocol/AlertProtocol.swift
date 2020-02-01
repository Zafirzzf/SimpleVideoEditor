//
//  AlertType.swift
//  HappyBonus
//
//  Created by 周正飞 on 2019/1/6.
//  Copyright © 2019年 MIX. All rights reserved.
//

import UIKit

/// 抽象弹窗公共逻辑
protocol AlertProtocol where Self: UIView {
    /// 配置弹窗内容, 不能主动调用
    func show()
    func dismiss()
    var leftMargin: CGFloat { get }
}

extension AlertProtocol {
    
    func show() {
        VCManager.windowTopVC()?.view.endEditing(true)
        let backgroundView = BackgroundView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0)
        backgroundView.whenTap { [unowned self] (_) in
            self.tapEmptyArea()
        }
        UIWindow.keyWindow.addSubview(backgroundView)
        backgroundView.addSubview(self)
        self.snp.makeConstraints {
            $0.left.equalTo(leftMargin)
            $0.right.equalTo(-leftMargin)
            $0.centerX.equalTo(SCREEN_WIDTH.half)
            $0.centerY.equalTo(SCREEN_HEIGHT.half)
        }
        backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0.5)
    }
    
    func dismiss() {
        let backgroundView = getBackgroundView()
        backgroundView.removeFromSuperview()
    }
    
    // 默认点击空白的方法
    private func tapEmptyArea() {
        dismiss()
    }
    
    private func getBackgroundView() -> BackgroundView {
        return UIWindow.keyWindow.subviews.first(where: { $0 is BackgroundView }) as! BackgroundView
    }
}
private class BackgroundView: UIView {
    
}
