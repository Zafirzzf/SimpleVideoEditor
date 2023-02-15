//
//  SettingItem.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import MessageUI

struct SettingItem {
    let title: String
    let action: VoidCallback
}

extension SettingItem {
    static var items: [SettingItem] {
        let gotoComment = SettingItem(title: "前往评论".international) {
            URL(string: "itms-apps://itunes.apple.com/cn/app/id1496721634?mt=8&action=write-review").on {
                UIApplication.shared.open($0, options: [:], completionHandler: nil)
            }
        }
        let sendEmail = SettingItem(title: "意见反馈".international) {
            VCManager.windowTopVC().on {
                EmailSender.shared.show(from: $0)
            }
        }
        let shareApp = SettingItem(title: "分享应用".international) {
            let items = ["SimplePlayer-学舞好帮手", "icon".toImage(), URL(string: "itms-apps://itunes.apple.com/app/id1496721634")!] as [Any]
            let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
            VCManager.windowTopVC().on {
                $0.present(activity, animated: true, completion: nil)
            }
        }
        return [gotoComment, sendEmail, shareApp]
    }
}


