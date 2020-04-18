//
//  EmailSender.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import MessageUI

class EmailSender: NSObject {
    static let shared = EmailSender()
    private let mailVC: MFMailComposeViewController
    
    private override init() {
        self.mailVC = MFMailComposeViewController()
        super.init()

        guard MFMailComposeViewController.canSendMail() else {
            HudManager.shared.showText("未开通邮件服务".international)
            return
        }
        self.mailVC.then {
            $0.mailComposeDelegate = self
            $0.setToRecipients(["Zoolofty@163.com"])
            $0.setSubject("邮件主题".international)
            let body = """
            \("设备版本".international): \(UIDevice.current.systemVersion)
            \("设备型号".international): \(DeviceInfo.getVersion().rawValue)
            \("App版本".international): \(DeviceInfo.bundleVersion())
            """
            $0.setMessageBody(body, isHTML: false)
        }
    }
    
    func show(from vc: UIViewController) {
        vc.present(mailVC, animated: true, completion: nil)
    }
}

extension EmailSender: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailVC.dismiss(animated: true, completion: nil)
    }
}
