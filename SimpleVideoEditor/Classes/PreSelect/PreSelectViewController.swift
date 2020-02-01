//
//  PreSelectViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class PreSelectViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIButton().nb.font(15.fontMedium)
            .title("选择视频".international)
            .titleColor(UIColor.black)
            .whenTap { [unowned self] in
                self.present(MediaPickerViewController(videoResultCallback: { (result) in
                    UIWindow.keyWindow.rootViewController = MainPlayerViewController(video: result)
                }), animated: true, completion: nil)
        }.addToSuperView(self.view)
            .base.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
