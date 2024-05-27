//
//  MainPlayerViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import RxSwift
import RxCocoa
import StoreKit
import DeviceDefine

class MainPlayerViewController: BaseViewController {
    
    var videoItem: VideoPickItem
    let player: AVPlayer
    var playerItem: AVPlayerItem
    lazy var vm = PlayerViewModel(player: player, videoItem: self.videoItem)
    lazy var playerLayer = AVPlayerLayer(player: player)
    let rxBag = DisposeBag()
    let containerView = UIView()
    var statusBarHidden = true
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    init(video: VideoPickItem) {
        self.videoItem = video
        playerItem = AVPlayerItem(asset: video.asset)
        player = AVPlayer(playerItem: playerItem)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showVC = self
        setup()
        setupBottomControlView()
        setupPlayer()
        if PreferenceConfig.openAppTimes == 1 {
            SKStoreReviewController.requestReview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.input.viewDisappear.accept(())
    }
    
    override var prefersStatusBarHidden: Bool { statusBarHidden }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

}

// MARK: - 事件响应
private extension MainPlayerViewController {
    func clickReselectVideo() {
        MediaPickerViewController.checkPhotoLibraryPermission {
            self.present(MediaPickerViewController(videoResultCallback: { (videoItem) in
                self.videoItem = videoItem
                self.vm.videoItem.accept(videoItem)
                self.vm.playState.accept(.playing)
                self.vm.playRate.accept(.normal)
                self.setupPlayer()
            }))
        }
    }
    
    func clickSaveVideo() {
        let exportVC = ExportViewController()
        push(exportVC)
        vm.playState.accept(.pause)
        VideoManager.outputVideo(of: videoItem, complete: exportVC.finish)
    }
}

// MARK: - 基础配置
private extension MainPlayerViewController {
    func setup() {
        view.backgroundColor = .blackLight
        view.addSubview(containerView)
        playerLayer.videoGravity = .resizeAspect
        vm.output.playerFrame.drive(playerLayer.rx.frame)
            .disposed(by: rxBag)
        vm.mirrorIsOpen.asDriver().drive(playerLayer.rx.mirror)
            .disposed(by: rxBag)
        vm.isFullScreen.asDriver()
            .drive(containerView.rx.rotation)
            .disposed(by: rxBag)
        vm.output.statusBarHidden
            .drive(self.rx.statusBarHidden)
            .disposed(by: rxBag)
        containerView.whenTap { [unowned self] (tap) in
            self.vm.input.playerViewTap.accept(tap.location(in: self.containerView))
        }
        containerView.layer.addSublayer(playerLayer)
        let backButton = UIButton().nb
            .image("back".toImage())
            .addToSuperView(containerView)
            .whenTap { [unowned self] in
                self.vm.input.changeFullScreen.accept(())
        }.base
        vm.output.backButtonIsHidden
            .drive(backButton.rx.isHidden)
            .disposed(by: rxBag)
        
        let selectVideoButton = CustomImagePositionButton(position: .right).nb
            .title("选择视频".international)
            .titleColor(.white)
            .font(14.font)
            .image("arrow down".toImage())
            .whenTap { [unowned self] in
                self.clickReselectVideo()
            }.addToSuperView(containerView).base
        vm.output.selectVideoHidden
            .drive(selectVideoButton.rx.isHidden)
            .disposed(by: rxBag)
        
        let saveButton = UIButton().nb
            .image("save".toImage())
            .addToSuperView(containerView)
            .whenTap { [unowned self] in
                ZFAlertView(title: KeyString.saveMirrorText*,
                            leftTitle: KeyString.cancel*,
                            rightTitle: KeyString.save*) { (isLeft) in
                                guard !isLeft else { return }
                                self.clickSaveVideo()
                }.show()
            }.base
        
        let settingButton = UIButton().nb
            .image("setting".toImage())
            .addToSuperView(containerView)
            .whenTap {
                SettingListView().show()
        }.base
        
        vm.output.saveButtonHidden
            .drive(saveButton.rx.isHidden)
            .disposed(by: rxBag)
        vm.output.settingButtonHidden
            .drive(settingButton.rx.isHidden)
            .disposed(by: rxBag)
        backButton.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(15)
        }
        settingButton.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.width.height.equalTo(25)
            $0.centerY.equalTo(selectVideoButton)
        }
        selectVideoButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            $0.centerX.equalToSuperview()
        }
        saveButton.snp.makeConstraints {
            $0.centerY.equalTo(selectVideoButton)
            $0.right.equalTo(-15)
            $0.width.height.equalTo(35)
        }
    }
    
    func setupPlayer() {
        playerItem = AVPlayerItem(asset: videoItem.asset)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func setupBottomControlView() {
        let bottom = PlayerControlBottomView()
        containerView.addSubview(bottom)
        bottom.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        let optionView = PlayerControlOptionView()
        containerView.addSubview(optionView)
        optionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottom.snp.top)
            $0.height.equalTo(50)
        }
        bottom.playPauseButton.rx.tap
            .bind(to: vm.controlVM.input.playOrPause)
            .disposed(by: rxBag)
        bottom.progressView.rx.value
            .bind(to: vm.controlVM.input.dragProgress)
            .disposed(by: rxBag)
        bottom.touchup.bind(to: vm.controlVM.input.sliderTouchup)
            .disposed(by: rxBag)
        bottom.fullScreenButton.rx.tap
            .bind(to: vm.input.changeFullScreen)
            .disposed(by: rxBag)
        optionView.mirrorTap.bind(to: vm.input.mirrorTap)
            .disposed(by: rxBag)
        optionView.rateSelect.bind(to: vm.input.rateSelect)
            .disposed(by: rxBag)
        optionView.musicTap.bind(to: vm.input.pickMusic)
            .disposed(by: rxBag)
        
        vm.bottomControlHidden.asObservable()
            .bind(to: bottom.rx.animationHidden,
                  optionView.rx.animationHidden)
            .disposed(by: rxBag)
        vm.mirrorIsOpen.asDriver()
            .drive(optionView.mirrorButton.rx.isSelected)
            .disposed(by: rxBag)
        vm.playRate.asDriver(onErrorJustReturn: .normal)
            .drive(player.rx.rate)
            .disposed(by: rxBag)
        vm.output.rateText
            .drive(optionView.rateButton.rx.title())
            .disposed(by: rxBag)
        vm.output.rateButtonSelected
            .drive(optionView.rateButton.rx.isSelected)
            .disposed(by: rxBag)
        vm.controlVM.output.playPauseIcon
            .drive(bottom.playPauseButton.rx.image())
            .disposed(by: rxBag)
        vm.controlVM.output.progress
            .drive(bottom.progressView.rx.value)
            .disposed(by: rxBag)
        vm.controlVM.output.timeFormate
            .drive(bottom.timeLabel.rx.text)
            .disposed(by: rxBag)
        vm.output.fullScreenHidden
            .drive(bottom.fullScreenButton.rx.isHidden)
            .disposed(by: rxBag)
        vm.playState.bind(to: self.rx.playStateAndUpdateRate)
            .disposed(by: rxBag)
    }
}

extension Reactive where Base: UIView {
    var rotation: Binder<Bool> {
        Binder<Bool>(self.base) { (view, isFullScreen) in
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            UIView.animate(withDuration: 0.15, animations: {
                if isFullScreen {
                    view.frame = [STATUS_BAR_HEIGHT, 0, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - TAB_IPHONEX_MARGIN, SCREEN_WIDTH]
                    view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                } else {
                    view.transform = CGAffineTransform.identity
                    view.frame = [0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_IPHONEX_MARGIN - 60]
                }
                view.center = CGPoint(x: SCREEN_WIDTH.half, y: SCREEN_HEIGHT.half)
            }) { (finish) in
                
            }
        }
    }
    
    var animationHidden: Binder<Bool> {
        Binder<Bool>(self.base) { (view, hidden) in
            UIView.animate(withDuration: 0.25, animations: {
                view.alpha = hidden ? 0 : 1
            })
        }
    }
}

extension Reactive where Base == AVPlayer {
    var playState: Binder<PlayState> {
        Binder<PlayState>(self.base) { (player, state) in
            state == .playing ? player.play() : player.pause()
        }
    }
    var rate: Binder<PlayRateType> {
        Binder<PlayRateType>(self.base) { (player, rate) in
            player.customSetRate(rate)
        }
    }
}

extension Reactive where Base: CALayer {
    var frame: Binder<CGRect> {
        Binder<CGRect>(self.base) { (layer, frame) in
            layer.frame = frame
        }
    }
    var mirror: Binder<Bool> {
        Binder<Bool>(self.base) { (layer, mirror) in
            UIView.animate(withDuration: 0.15, animations: {
                if mirror {
                    layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
                } else {
                    layer.setAffineTransform(CGAffineTransform.identity)
                }
            }, completion: nil)
        }
    }
}

extension Reactive where Base == MainPlayerViewController {
    var statusBarHidden: Binder<Bool> {
        Binder<Bool>(self.base) { (vc, hidden) in
            vc.statusBarHidden = hidden
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var playStateAndUpdateRate: Binder<PlayState> {
        Binder<PlayState>(self.base) { (playerVC, state) in
            if state == .playing {
                playerVC.player.play()
                playerVC.player.customSetRate(playerVC.vm.playRate.value)
            } else {
                playerVC.player.pause()
            }
        }
    }
}
