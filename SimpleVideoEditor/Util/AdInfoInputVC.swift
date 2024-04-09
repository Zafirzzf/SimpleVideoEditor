//
//  AdInfoInputVC.swift
//  SimpleVideoEditor
//
//  Created by Zafir on 2024/4/4.
//  Copyright © 2024 周正飞. All rights reserved.
//

import UIKit
import SnapKit
import AHProgressView

final class AdInfoInputVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let appIdTF = AdTextField().then {
            $0.placeholder = "请输入appId"
        }
        let shotId1 = AdTextField().then {
            $0.placeholder = "请输入代码位id1"
        }
        let shotId2 = AdTextField().then {
            $0.placeholder = "请输入代码位id2"
        }
        let shotId3 = AdTextField().then {
            $0.placeholder = "请输入代码位id3"
        }
        let confirmButton = UIButton(title: "确认", titleColor: .red, titleFont: .bold(size: 16), backGroundColor: .black)
        confirmButton.addTouch { [unowned self] in
            if appIdTF.text?.isEmpty == true || shotId1.text!.isEmpty {
                AHProgressView.showTextToast(message: "appId和一个广告位必填")
                return
            }
            
//            PreferenceConfig.adAppId = appIdTF.text!
//            PreferenceConfig.adShotIds = [shotId1.text!, shotId2.text!, shotId3.text!].filter {
//                !$0.isEmpty
//            }
            self.dismiss(animated: true)
        }
        
        
        view.addSubviews(appIdTF, shotId1, shotId2, shotId3, confirmButton)
        
        appIdTF.snp.makeConstraints {
            $0.top.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        shotId1.snp.makeConstraints {
            $0.top.equalTo(appIdTF.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(appIdTF)
        }
        shotId2.snp.makeConstraints {
            $0.top.equalTo(shotId1.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(appIdTF)
        }
        shotId3.snp.makeConstraints {
            $0.top.equalTo(shotId2.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(appIdTF)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(shotId3.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
    }
}

private final class AdTextField: UITextField {
    
    required init?(coder: NSCoder) { nil }
    
    init() {
        super.init(frame: .zero)
        borderWidth = 1
        borderColor = .black
    }
}
