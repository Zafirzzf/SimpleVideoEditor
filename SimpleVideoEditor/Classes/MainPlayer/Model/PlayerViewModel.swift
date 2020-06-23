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

enum PlayState {
    case playing
    case pause
    func toggle() -> PlayState {
        return self == .playing ? .pause : .playing
    }
}

class PlayerViewModel {
    
    struct Input {
        let mirrorTap = PublishRelay<Void>()
        let rateSelect = PublishRelay<Void>()
        let pickMusic = PublishRelay<Void>()
        let changeFullScreen = PublishRelay<Void>()
        let playerViewTap = PublishRelay<CGPoint>()
        let viewDisappear = PublishRelay<Void>()
    }
    struct Output {
        let playerFrame: Driver<CGRect>
        let fullScreenHidden: Driver<Bool>
        let rateText: Driver<String>
        let rateButtonSelected: Driver<Bool>
        let backButtonIsHidden: Driver<Bool>
        let selectVideoHidden: Driver<Bool>
        let saveButtonHidden: Driver<Bool>
        var settingButtonHidden: Driver<Bool> {
            backButtonIsHidden.map { !$0 }
        }
        let statusBarHidden: Driver<Bool>
    }
    
    let input: Input
    let output: Output
    let controlVM: PlayControlVM
    var playState = BehaviorRelay<PlayState>(value: .playing)
    let videoItem: BehaviorRelay<VideoPickItem>
    let mirrorIsOpen = BehaviorRelay<Bool>(value: false)
    let playRate = BehaviorRelay<PlayRateType>(value: .normal)
    let isFullScreen = BehaviorRelay<Bool>(value: false)
    let bottomControlHidden = BehaviorRelay<Bool>(value: false)
    let timeControler: PlayerTimeController
    
    private let rxBag = DisposeBag()

    init(player: AVPlayer, videoItem: VideoPickItem) {
        self.videoItem = BehaviorRelay<VideoPickItem>(value: videoItem)
        timeControler = PlayerTimeController(player: player)
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
        let timeReply = timeControler.playTime
        let progressObserver = timeReply.map { Float($0.current / $0.total) }
        let timeFormatObserver = timeReply
            .map { $0.current.playTimeFormat + "/" + $0.total.playTimeFormat }
        let fullScreenHidden = self.videoItem
            .map { !$0.isHorizontal }
            .asDriver(onErrorJustReturn: false)
        let saveButtonHidden = Observable.combineLatest(isFullScreen.asObservable(), mirrorIsOpen.asObservable()) { $0 || !$1 }
        controlVM = .init(output: .init(progress: progressObserver.asDriver(onErrorJustReturn: 0),
                                        timeFormate: timeFormatObserver.asDriver(onErrorJustReturn: ""),
                                        fullScreenHidden: fullScreenHidden),
                                        playState: playState.asDriver())
        output = .init(playerFrame: playerFrame.asDriver(onErrorJustReturn: .zero),
                       fullScreenHidden: fullScreenHidden,
                       rateText: playRate.map { String("x \($0.rawValue)")}.asDriver(onErrorJustReturn: ""),
                       rateButtonSelected: playRate.map { $0 != .normal }.asDriver(onErrorJustReturn: false),
                       backButtonIsHidden: isFullScreen.map { !$0 }.asDriver(onErrorJustReturn: true),
                       selectVideoHidden: isFullScreen.map { $0 }.asDriver(onErrorJustReturn: true),
                       saveButtonHidden: saveButtonHidden.asDriver(onErrorJustReturn: false),
                       statusBarHidden: isFullScreen.map { $0 }.asDriver(onErrorJustReturn: false))
        input = .init()
        timeControler.playCompleteCallback = { [unowned self] in
            self.seekTimeCompletion(player: $0)
        }
        playState.map { $0 == .playing }
            .bind(to: timeControler.timer.rx.start)
            .disposed(by: rxBag)
        
        // 点击播放暂停按钮
        controlVM.input.playOrPause
            .flatMapLatest { Observable.just(self.playState.value.toggle()) }
            .bind(to: playState)
            .disposed(by: rxBag)
        
        // 拖动进度条
        controlVM.input.dragProgress.skip(1).subscribe(onNext: { progress in
            player.pause()
            player.seekToTime(of: progress)
        }).disposed(by: rxBag)
        
        // 松开进度条
        controlVM.input.sliderTouchup
            .flatMapLatest { _ in Observable.just(self.playState.value) }
            .bind(to: playState)
            .disposed(by: rxBag)
        
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
        // 提取音乐
        input.pickMusic.subscribe(onNext: {
            FileNameInputAlert {
                MusicEditor().pickMusic(of: videoItem, fileName: $0, complete: {  })
            }.show()
        }).disposed(by: rxBag)
        
        // 切换全屏
        input.changeFullScreen
            .flatMapLatest { Observable<Bool>.just(!self.isFullScreen.value) }
            .bind(to: isFullScreen)
            .disposed(by: rxBag)
        
        // 界面消失
        input.viewDisappear.subscribe(onNext: { [unowned self] in
            self.playState.accept(.pause)
        }).disposed(by: rxBag)
        
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
        if playState.value == .playing {
            playState.accept(self.playState.value)
            playRate.accept(self.playRate.value)
        }
    }
}

extension Double {
    var playTimeFormat: String {
        String(format: "%02d:%02.0f", Int(self) / 60, self.truncatingRemainder(dividingBy: 60))
    }
}

extension Reactive where Base == Timer {
    var start: Binder<Bool> {
        Binder<Bool>(self.base) { (timer, start) in
            start ? timer.goOn() : timer.pause()
        }
    }
}
