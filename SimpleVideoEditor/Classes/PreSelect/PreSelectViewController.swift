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
import AHProgressView
import AudioToolbox

class PreSelectViewController: BaseViewController {

    weak var idfaLabel: UILabel?
    
    let timeButton = UIButton(title: "点击开始倒计时10分钟", titleColor: .white, titleFont: .bold(size: 20))
    weak var countDownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        timeButton.addTouch { [unowned self] in
            self.setupCountDownView(minute: 5)
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            self.requestIDFAPermission()
            self.idfaLabel?.text = ASIdentifierManager.shared().advertisingIdentifier.uuidString
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
        CSJManager.shared.resultCallback = {
            self.view.backgroundColor = $0 ? .green.withAlphaComponent(0.7) : .red.withAlphaComponent(0.7)
        }
        
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
                if PreferenceConfig.csjIsTestAd {
                    ZFAlertView(title: "确认使用测试代码位吗", leftTitle: "取消", rightTitle: "确认") { isLeft in
                        if !isLeft {
                            CSJManager.shared.loadAdData(isRetry: false)

                        }
                    }.show()
                } else {
                    CSJManager.shared.loadAdData(isRetry: false)
                }
        }.base
        
        let musicFileButton = OptionButton(position: .top)
            .nb.image("musicFile".toImage())
            .font(20.fontBold)
            .hidden(true)
            .title("插屏广告".international)
            .addToSuperView(self.view)
            .whenTap { [unowned self] in
//                CSJInsertAdManager.shared.loadAdData(isRetry: false)
//                self.push(MusicFileViewController())
        }.base
        
        let idfaLabel = UILabel(
            font: .regular(size: 13),
            textColor: .white,
            text: ASIdentifierManager.shared().advertisingIdentifier.uuidString
        ).then {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer.self) { _ in
                UIPasteboard.general.string = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                AHProgressView.showTextToast(message: "已复制idfa")
            }
        }
        self.idfaLabel = idfaLabel
        view.addSubviews(idfaLabel, timeButton)
        
        let historyButton = UIButton(title: "历史记录",
                                     titleColor: .white,
                                     titleFont: .bold(size: 20)
        )
        historyButton.addTouch {
            _ = AdLogWrapper.shared
            self.present(AHLogRecorderListVC(dataSource: AdLogWrapper.adLog))
        }
        view.addSubview(historyButton)
        
        let adTestSwitch = UISwitch()
        adTestSwitch.isHidden = true
        adTestSwitch.isOn = PreferenceConfig.csjIsTestAd
        adTestSwitch.addTarget(self, action: #selector(adSwitchAction), for: .valueChanged)
        view.addSubview(adTestSwitch)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(NAVIGATION_BAR_HHEIGHT + 5)
            $0.centerX.equalToSuperview()
        }
        subTitlteLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
        }
        timeButton.snp.makeConstraints {
            $0.bottom.equalTo(selectButton.snp.top).offset(-40)
            $0.centerX.equalToSuperview()
        }
        selectButton.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
        }
        historyButton.snp.makeConstraints {
            $0.centerY.equalTo(musicFileButton)
            $0.centerX.equalToSuperview()
        }
        idfaLabel.snp.makeConstraints {
            $0.top.equalTo(selectButton.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        adTestSwitch.snp.makeConstraints {
            $0.centerY.equalTo(musicFileButton)
            $0.leading.equalTo(musicFileButton.snp.trailing).offset(20)
        }
        musicFileButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    func adSwitchAction(_ switchButton: UISwitch) {
        PreferenceConfig.csjIsTestAd = switchButton.isOn
    }
    
    private func setupCountDownView(minute: Int) {
        
        countDownTimer?.invalidate()
        var seconds: Int = 10 * 60
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] in
            seconds -= 1
            timeButton.setTitle(hhMMss(seconds: seconds), for: .normal)
            if seconds == 0 {
                $0.invalidate()
                timeButton.setTitleColor(.red, for: .normal)
                timeButton.setTitle("10分钟到,再次点击可重新计时", for: .normal)
                AudioServicesPlaySystemSound(1521)
            }
        }
        countDownTimer?.fire()
    }
}

func hhMMss(seconds: Int) -> String {
    let hours = seconds / 3600
    let minute = seconds / 60 % 60
    let second = seconds % 60
    return String(format: "%0.2d:%0.2d:%0.2d", hours, minute, second)
}
