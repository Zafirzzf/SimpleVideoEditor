//
//  MusicFileVM.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/19.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

class MusicFileVM {
    struct Output {
        var models: BehaviorRelay<[MusicItem]?> = {
            let items = FileManager.default.enumerator(atPath: musicCacheDirectory)?
                .compactMap { $0 as? String }
                .map { musicCacheDirectory + "/\($0)" }
                .map(MusicItem.init)
            return .init(value: items)
        }()
        var currentMusic = BehaviorRelay<MusicItem?>(value: nil)
    }
    struct Input {
        let selectMusic = PublishRelay<MusicItem>()
        let deleteMusic = PublishRelay<Int>()
    }
    
    let output: Output
    let input: Input = Input()
    let controlVM: PlayControlVM
    let timeController: PlayerTimeController
    
    let playState = BehaviorRelay<PlayState>(value: .pause)
    let rxBag = DisposeBag()
    
    init(player: AVPlayer) {
        output = Output()
        timeController = PlayerTimeController(player: player)
        let timeReply = timeController.playTime
        let progressObserver = timeReply.map { Float($0.current / $0.total) }
        let timeFormatObserver = timeReply
            .map { $0.current.playTimeFormat + "/" + $0.total.playTimeFormat }
        controlVM = PlayControlVM(output: .init(progress: progressObserver.asDriver(onErrorJustReturn: 0),
                                                timeFormate: timeFormatObserver.asDriver(onErrorJustReturn: ""),
                                                fullScreenHidden: .just(true)),
                                                playState: playState.asDriver())
        input.selectMusic
            .flatMap { _ in Observable.just(PlayState.playing) }
            .bind(to: playState)
            .disposed(by: rxBag)
        input.selectMusic.bind(to: output.currentMusic)
            .disposed(by: rxBag)
        input.deleteMusic.subscribe(onNext: { [unowned self] index in
            guard var models = self.output.models.value else { return }
            let removeModel = models.remove(at: index)
            try? FileManager.default.removeItem(atPath: removeModel.path)
            self.output.models.accept(models)
        }).disposed(by: rxBag)
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
    }
}

