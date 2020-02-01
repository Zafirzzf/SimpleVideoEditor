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
        view.backgroundColor = .black
        
        let titleLabel = UILabel().nb
            .font(UIFont(name: "Helvetica-BoldOblique", size: 25)!)
            .text("Simple Video")
            .textColor(UIColor.white)
            .addToSuperView(self.view).base
            
        let subTitlteLabel = UILabel().nb
            .font(20.fontMedium)
            .textColor(UIColor.white)
            .numberOfLines(0)
            .textAlignment(.center)
            .text("简单易用的视频播放器\n 镜像/慢速 \n 可保存到本地".international)
            .addToSuperView(self.view).base
        let endLabel = UILabel().nb
            .font(15.font)
            .textColor(UIColor.white)
            .text("更多功能敬请期待...".international)
            .addToSuperView(self.view).base
        
        let selectButton = UIButton().nb.font(15.fontMedium)
            .border(width: 5, color: UIColor.white)
            .cornerRadius(40)
            .maskToBounds()
            .backgroundImage(UIImage.graident(colors: UIColor.confirmGradientColors.map { $0.cgColor }, size: CGSize(width: 80, height: 80)))
            .image("selectVideo".toImage())
            .addToSuperView(self.view)
            .whenTap { [unowned self] in
                MediaPickerViewController.checkPhotoLibraryPermission {
                    self.present(MediaPickerViewController(videoResultCallback: { (result) in
                        UIWindow.keyWindow.rootViewController = MainPlayerViewController(video: result)
                    }), animated: true, completion: nil)
                }
        }.base
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(NAVIGATION_BAR_HHEIGHT + 5)
            $0.centerX.equalToSuperview()
        }
        subTitlteLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        selectButton.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
        }
        endLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-TAB_IPHONEX_MARGIN - 50)
        }
    }
}
