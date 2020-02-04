//
//  PlayerViewModel.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

class PlayerViewModel {
    
    enum PlayState {
        case playing
        case pause
        func toggle() -> PlayState {
            return self == .playing ? .pause : .playing
        }
    }
    struct Input {
        let playOrPause = PublishRelay<Void>()
        let dragProgress = PublishRelay<Float>()
        let sliderTouchup = PublishRelay<Float>()
        let playToEnd = PublishRelay<Void>()
        let mirrorTap = PublishRelay<Void>()
        let rateSelect = PublishRelay<Void>()
        let changeFullScreen = PublishRelay<Void>()
        let playerViewTap = PublishRelay<CGPoint>()
    }
    struct Output {
        let playPauseIcon: Driver<UIImage>
        let progress: Driver<Float>
        let timeFormate: Driver<String>
        let playerFrame: Driver<CGRect>
        let fullScreenHidden: Driver<Bool>
        let rateText: Driver<String>
        let rateButtonSelected: Driver<Bool>
        let backButtonIsHidden: Driver<Bool>
        let selectVideoHidden: Driver<Bool>
        let saveButtonHidden: Driver<Bool>
        let statusBarHidden: Driver<Bool>
    }
    
    let input: Input
    let output: Output
    var playState = BehaviorRelay<PlayState>(value: .playing)
    let videoItem: BehaviorRelay<VideoPickItem>
    let mirrorIsOpen = BehaviorRelay<Bool>(value: false)
    let playRate = BehaviorRelay<PlayRateType>(value: .normal)
    let isFullScreen = BehaviorRelay<Bool>(value: false)
    let bottomControlHidden = BehaviorRelay<Bool>(value: false)

    private var progressTimer: Timer?
    private let rxBag = DisposeBag()
    private var isDragingSlider = false
    
    deinit {
        progressTimer?.invalidate()
    }
    init(player: AVPlayer, videoItem: VideoPickItem) {
        self.videoItem = BehaviorRelay<VideoPickItem>(value: videoItem)
        let playerFrame = Observable.combineLatest(isFullScreen.asObservable(), self.videoItem.asObservable()) { (isFullScreen, item) -> CGRect in
            if item.isHorizontal {
                let videoHeight = item.videoHeight(from: SCREEN_WIDTH)
                if isFullScreen {
                    return [0, 0, SCREEN_HEIGHT, SCREEN_WIDTH]
                } else {
                    return [0, (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - TAB_IPHONEX_MARGIN - videoHeight) / 2, SCREEN_WIDTH, videoHeight]
                }
            } else {
                let videoHeight = item.videoHeight(from: SCREEN_WIDTH - 30 * 2)
                return [30, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 2 * 30, videoHeight]
            }
        }
        
        let playPauseIcon = playState.asDriver()
            .map { $0 == .pause ? "play".toImage() : "pause".toImage() }
        
        func timeFormat(of number: Double) -> String {
            String(format: "%02d:%02.0f", Int(number) / 60, number.truncatingRemainder(dividingBy: 60))
        }
        let timeReply = BehaviorRelay<(current: Double, total: Double)>(value: (0, 0))
        let progressObserver = timeReply.map { Float($0.current / $0.total) }
        let timeFormatObserver = timeReply
            .map {
                timeFormat(of: $0.current) + "/" + timeFormat(of: $0.total)
                
        }
        let fullScreenHidden = self.videoItem
            .map { !$0.isHorizontal }
            .asDriver(onErrorJustReturn: false)
        let saveButtonHidden = Observable.combineLatest(isFullScreen.asObservable(), mirrorIsOpen.asObservable()) { $0 || !$1 }
        
        output = .init(playPauseIcon: playPauseIcon,
                       progress: progressObserver.asDriver(onErrorJustReturn: 0),
                       timeFormate: timeFormatObserver.asDriver(onErrorJustReturn: ""),
                       playerFrame: playerFrame.asDriver(onErrorJustReturn: .zero),
                       fullScreenHidden: fullScreenHidden,
                       rateText: playRate.map { String("x \($0.rawValue)")}.asDriver(onErrorJustReturn: ""),
                       rateButtonSelected: playRate.map { $0 != .normal }.asDriver(onErrorJustReturn: false),
                       backButtonIsHidden: isFullScreen.map { !$0 }.asDriver(onErrorJustReturn: true),
                       selectVideoHidden: isFullScreen.map { $0 }.asDriver(onErrorJustReturn: true),
                       saveButtonHidden: saveButtonHidden.asDriver(onErrorJustReturn: false),
                       statusBarHidden: isFullScreen.map { $0 }.asDriver(onErrorJustReturn: false))
        input = .init()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            guard !self.isDragingSlider else { return }
            let totalTimeSec = Double(CMTimeGetSeconds(player.currentItem!.duration))
            let currentTimeSec = Double(CMTimeGetSeconds(player.currentItem!.currentTime()))
            if currentTimeSec == totalTimeSec {
                // 播放完毕
                player.seek(to: CMTime(seconds: 0, preferredTimescale: 1)) { (finish) in
                    self.seekTimeCompletion(player: player)
                }
            }
            
            timeReply.accept((currentTimeSec.validNumber, totalTimeSec.validNumber))
        }
        timer.fire()
        RunLoop.main.add(timer, forMode: .common)
        playState.map { $0 == .playing }
            .bind(to: timer.rx.start)
            .disposed(by: rxBag)
        self.progressTimer = timer
        
        // 点击播放暂停按钮
        input.playOrPause
            .flatMapLatest { Observable.just(self.playState.value.toggle()) }
            .bind(to: playState)
            .disposed(by: rxBag)
        
        // 拖动进度条
        input.dragProgress.skip(1).subscribe(onNext: { [unowned self] progress in
            self.isDragingSlider = true
        }).disposed(by: rxBag)
        
        // 松开进度条
        input.sliderTouchup.subscribe(onNext: { [unowned self] value in
            let totalTimeSec = Double(CMTimeGetSeconds(player.currentItem!.duration))
            let targetTime = CMTime(seconds: totalTimeSec * Double(value), preferredTimescale: 100000)
            player.seek(to: targetTime) { (finish) in
                self.seekTimeCompletion(player: player)
            }
        }).disposed(by: rxBag)
        
        // 点击镜像
        input.mirrorTap
            .flatMapLatest { Observable<Bool>.just(!self.mirrorIsOpen.value) }
            .bind(to: mirrorIsOpen)
            .disposed(by: rxBag)
        
        // 播放速率
        input.rateSelect
            .skipWhile({ self.playState.value != .playing })
            .flatMapLatest { Observable<PlayRateType>.just( self.playRate.value.toggle()) }
            .bind(to: playRate)
            .disposed(by: rxBag)
        
        // 切换全屏
        input.changeFullScreen
            .flatMapLatest { Observable<Bool>.just(!self.isFullScreen.value) }
            .bind(to: isFullScreen)
            .disposed(by: rxBag)
        
        // 点击屏幕
        Observable.combineLatest(input.playerViewTap.asObservable(), output.playerFrame.asObservable()) {
            $1.contains($0)
        }.subscribe(onNext: { [unowned self] valid in
            guard valid else { return }
            if self.isFullScreen.value {
                self.bottomControlHidden.accept(!self.bottomControlHidden.value)
            } else {
                self.playState.accept(self.playState.value.toggle())
            }
        }).disposed(by: rxBag)
        isFullScreen.map { $0 }
            .bind(to: bottomControlHidden)
            .disposed(by: rxBag)
    }
    
    func seekTimeCompletion(player: AVPlayer) {
        isDragingSlider = false
        if playState.value == .playing {
            playState.accept(self.playState.value)
            playRate.accept(self.playRate.value)
        }
    }
}

extension Reactive where Base == Timer {
    var start: Binder<Bool> {
        Binder<Bool>(self.base) { (timer, start) in
            start ? timer.goOn() : timer.pause()
        }
    }
}
