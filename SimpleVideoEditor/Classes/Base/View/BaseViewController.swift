//
//  BaseViewController.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.modalPresentationStyle = .fullScreen
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - 便捷方法
extension BaseViewController {
    
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popOrDismiss() {
        if isNaviRoot {
            self.dismiss()
        } else {
            self.pop()
        }
    }
    func pop(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(_ animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func present(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    func showHud() {
        HudManager.shared.showHud()
    }
    
    func hideHud() {
        HudManager.shared.dismissHud()
    }
    
    func showHudText(_ text: String) {
        HudManager.shared.showText(text)
    }
    
    func hideNavigation(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing()
    }
}

