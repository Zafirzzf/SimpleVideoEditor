//
//  PlayerTimeGenerator.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/26.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import AVFoundation
import RxCocoa
import RxSwift

class PlayerTimeController {
    
    var timer: Timer!
    var playCompleteCallback: (AVPlayer) -> Void = { _ in }
    let playTime = BehaviorRelay<(current: Double, total: Double)>(value: (0, 0))
    
    deinit {
        timer?.invalidate()
    }
    
    init(player: AVPlayer) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] (_) in
            guard let self = self, let playerItem = player.currentItem else { return }
            let totalTimeSec = Double(CMTimeGetSeconds(playerItem.duration))
            let currentTimeSec = Double(CMTimeGetSeconds(playerItem.currentTime()))
            if currentTimeSec == totalTimeSec {
                // 播放完毕 重新播放
                player.seek(to: CMTime(seconds: 0, preferredTimescale: 1)) { (finish) in
                    self.playCompleteCallback(player)
                }
            }
            self.playTime.accept((currentTimeSec.validNumber, totalTimeSec.validNumber))
        })
        timer.fire()
        self.timer = timer
        RunLoop.main.add(timer, forMode: .common)
    }
}
