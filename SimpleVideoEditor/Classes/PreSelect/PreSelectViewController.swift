//
//  PreSelectViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import AHLogRecorder

class PreSelectViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            self.requestIDFAPermission()
            print("idfa 是: \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation()
    }

    func requestIDFAPermission() {
        guard #available(iOS 14, *) else {
            return
        }
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                print("请求结果 :", status.rawValue)
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .blackLight
        
        let titleLabel = UILabel().nb
            .font(UIFont(name: "Helvetica-BoldOblique", size: 25)!)
            .text("Simple Player")
            .textColor(UIColor.white)
            .addToSuperView(self.view).base
            
        let subTitlteLabel = UILabel().nb
            .font(20.fontMedium)
            .textColor(UIColor.white)
            .numberOfLines(0)
            .textAlignment(.center)
            .text(KeyString.mainIntroducation*)
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
                        UIWindow.keyWindow.rootViewController = BaseNavigationController(rootViewController: MainPlayerViewController(video: result))
                    }), animated: true, completion: nil)
                }
        }.base
        
        let musicFileButton = OptionButton(position: .top)
            .nb.image("musicFile".toImage())
            .title("提取的音乐".international)
            .addToSuperView(self.view)
            .whenTap { [unowned self] in
                CSJManager.shared.loadAdData()
//                self.push(MusicFileViewController())
        }.base
        musicFileButton.addGestureRecognizer(UILongPressGestureRecognizer.self) { _ in
            self.present(AHLogRecorderListVC(dataSource: adLog))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(NAVIGATION_BAR_HHEIGHT + 5)
            $0.centerX.equalToSuperview()
        }
        subTitlteLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
        }
        selectButton.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
        }
        musicFileButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.centerX.equalToSuperview()
        }
    }
}
