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
    
    private let timer: Timer
    
    init(player: AVPlayer) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            let totalTimeSec = Double(CMTimeGetSeconds(player.currentItem!.duration))
            let currentTimeSec = Double(CMTimeGetSeconds(player.currentItem!.currentTime()))
            if currentTimeSec == totalTimeSec {
                // 播放完毕
                player.seek(to: CMTime(seconds: 0, preferredTimescale: 1)) { (finish) in
                    self.seekTimeCompletion(player: player)
                }
            }
        })
    }
}
