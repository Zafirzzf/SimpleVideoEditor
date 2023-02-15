//
//  SheetProtocol.swift
//  SeekLightActor
//
//  Created by 周正飞 on 2019/10/30.
//  Copyright © 2019 周正飞. All rights reserved.
//

import Foundation
import UIKit

protocol SheetProtocol where Self: UIView {
    func show()
    func dismiss()
}

extension SheetProtocol {
    func show() {
        VCManager.windowTopVC()?.view.endEditing(true)
        let backgroundView = BackgroundView(frame: UIScreen.main.bounds, tapCallback: { [unowned self] in
            self.dismiss()
        })
        backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0)

        UIWindow.keyWindow.addSubview(backgroundView)
        let cornerContainer = createCornerContainerView()
        backgroundView.addSubview(cornerContainer)
        cornerContainer.addSubview(self)
        self.y += 25
        cornerContainer.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: self.height + 25 + TAB_IPHONEX_MARGIN)
        cornerContainer.addRoundedCorners(direction: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        UIView.animate(withDuration: 0.2, animations: {
            cornerContainer.y = SCREEN_HEIGHT - cornerContainer.height
            backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func dismiss() {
        let backgroundView = getBackgroundView()
        UIView.animate(withDuration: 0.2, animations: {
            backgroundView.subviews.first?.y = SCREEN_HEIGHT
            backgroundView.backgroundColor = UIColor.blackLight.withAlphaComponent(0)
        }, completion: { _ in
            backgroundView.removeFromSuperview()
        })
    }
    
    private func createCornerContainerView() -> UIView {
        let cornerView = UIView().nb
                            .backgroundColor(.white).base
        return cornerView
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
