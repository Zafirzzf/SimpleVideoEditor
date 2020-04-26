//
//  PlayControlVM.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/21.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PlayControlVM {
    struct Output {
        var playPauseIcon: Driver<UIImage>!
        let progress: Driver<Float>
        let timeFormate: Driver<String>
        let fullScreenHidden: Driver<Bool>
    }
    
    struct Input {
        let playOrPause = PublishRelay<Void>()
        let dragProgress = PublishRelay<Float>()
        let sliderTouchup = PublishRelay<Float>()
        let changeFullScreen = PublishRelay<Void>()
    }
    
    var output: Output
    let input = Input()
    
    init(output: Output, playState: Driver<PlayState>) {
        self.output = output
        self.output.playPauseIcon = playState.asDriver().map { $0 == .pause ? "play".toImage() : "pause".toImage() }
    }
}
