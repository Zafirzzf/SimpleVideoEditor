//
//  SideSheetProtocol.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

protocol SideSheetProtocol: UIView {
    func show()
    func dismiss()
}

extension SideSheetProtocol {
    func show() {
        VCManager.windowTopVC()?.view.endEditing(true)
        let backgroundView = BackgroundView(frame: UIScreen.main.bounds, tapCallback: { [unowned self] in
            self.dismiss()
        })
        backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0)
        backgroundView.addSubview(self)
        UIWindow.keyWindow.addSubview(backgroundView)
        self.x = -self.width
        UIView.animate(withDuration: 0.2, animations: {
            self.x = 0
            backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func dismiss() {
        let backgroundView = getBackgroundView()
        UIView.animate(withDuration: 0.2, animations: {
            self.x = -self.width
            backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0)
        }, completion: { _ in
            backgroundView.removeFromSuperview()
        })
    }
    
    private func getBackgroundView() -> BackgroundView {
        return UIWindow.keyWindow.subviews.first(where: { $0 is BackgroundView }) as! BackgroundView
    }
}

private class BackgroundView: UIView, UIGestureRecognizerDelegate {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    let tapCallback: () -> Void
    init(frame: CGRect, tapCallback: @escaping () -> Void) {
        self.tapCallback = tapCallback
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEmptyArea))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    @objc func tapEmptyArea() {
        tapCallback()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return true }
        return touchView == self
    }
}
