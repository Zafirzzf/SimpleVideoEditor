//
//  Created by Foxling on 16/8/2.
//

import UIKit
import AVFoundation

private var seekerKey = ""

extension AVPlayer {
    func seekToTime(of progress: Float) {
        if let duration = currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            let newChaseTime = CMTime(seconds: Float64(progress) * seconds, preferredTimescale: duration.timescale)
            guard newChaseTime.isValid, newChaseTime >= CMTime.zero else { return }
            var seeker = objc_getAssociatedObject(self, &seekerKey) as? AVPlayerSeeker
            if seeker == nil {
                seeker = AVPlayerSeeker(player: self)
                objc_setAssociatedObject(self, &seekerKey, seeker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            seeker?.seekSmoothly(to: newChaseTime, completion: nil)
        }
    }
    
    func fl_currentTime() -> CMTime {
        if let seeker = objc_getAssociatedObject(self, &seekerKey) as? AVPlayerSeeker {
            if seeker.isSeekInProgress {
                return seeker.chaseTime
            }
        }
        return currentTime()
    }
    
    func customSetRate(_ rate: PlayRateType) {
        guard let playerItem = currentItem else { return }
        let rateIsSlowest = rate == .slowest
        playerItem.tracks.forEach {
            if $0.assetTrack!.mediaType == AVMediaType.audio {
                $0.isEnabled = !rateIsSlowest
            }
        }
        self.rate = rate.rawValue
    }
}

private class AVPlayerSeeker {
    
    weak var player: AVPlayer?
    var isSeekInProgress = false
    var chaseTime = CMTime.zero
    var completions: [VoidCallback] = []
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func seekSmoothly(to newChaseTime: CMTime, completion: (VoidCallback)? = nil) {
        guard let player = player, let item = player.currentItem else {
            return
        }
        if newChaseTime > item.duration {
            return
        }
        if player.currentTime() != newChaseTime {
            chaseTime = newChaseTime
            if let c = completion {
                completions.append(c)
            }
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        } else {
            completion?()
        }
    }
    
    var readyObservable: ReadyObservable?
    func trySeekToChaseTime() {
        guard let player = player else {
            return
        }
        readyObservable?.cancel()
        readyObservable = nil
        if player.status == .readyToPlay {
            actuallySeekToTime()
        } else {
            readyObservable = ReadyObservable(player, { [weak self] in
                guard let s = self else { return }
                s.readyObservable = nil
                s.actuallySeekToTime()
            })
        }
    }
    
    func actuallySeekToTime() {
        guard let player = player else {
            return
        }
        isSeekInProgress = true
        player.seek(to: chaseTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { [weak self] isFinished in
            guard let s = self, let player = s.player else { return }
            DispatchQueue.main.async {
                if abs(CMTimeSubtract(player.currentTime(), s.chaseTime).seconds) < 0.1 {
                    s.seekComplete()
                } else {
                    s.trySeekToChaseTime()
                }
            }
        })
    }
    
    func seekComplete() {
        isSeekInProgress = false
        for c in self.completions {
            c()
        }
        self.completions.removeAll()
    }
}

private class ReadyObservable: NSObject {
    fileprivate var block: (() -> Void)
    fileprivate var player: AVPlayer
    fileprivate var isCancel: Bool = false
    init(_ player: AVPlayer, _ block: @escaping (() -> Void)) {
        self.block = block
        self.player = player
        super.init()
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if isCancel {
            return
        }
        if keyPath == "status" {
            if player.status == .readyToPlay {
                block()
            }
        }
    }
    func cancel() {
        if isCancel {
            return
        }
        isCancel = true
    }
    deinit {
        player.removeObserver(self, forKeyPath: "status")
    }
}
