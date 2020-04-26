//
//  MusicEditManager.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftDate

var musicCacheDirectory: String {
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + "/musicList"
    if FileManager.default.fileExists(atPath: cachePath) {
        return cachePath
    } else {
        do {
            try FileManager.default.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            return cachePath
        } catch {
            assertionFailure(error.localizedDescription)
            return ""
        }
    }
}

class MusicEditor {
    func pickMusic(of item: VideoPickItem) {
        let asset = item.asset
        let mixComposition = AVMutableComposition()
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            assertionFailure()
            return
        }
        do {
            try firstTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .audio).first!, at: .zero)
            guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else { return }
            exporter.outputURL = cacheAudioURL
            exporter.outputFileType = .m4a
            exporter.shouldOptimizeForNetworkUse = true
            exporter.exportAsynchronously {
                DispatchQueue.main.async {
                    print(exporter.status, "导出状态: ")
                    if exporter.status == .completed {
                        HudManager.shared.showSuccessHud("Yeah")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    var cacheAudioURL: URL? {
        let now = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH-mm"
        let timeString = dateFormater.string(from: now)
        let cachePath = musicCacheDirectory + "/\(timeString).m4a"
        return URL(fileURLWithPath: cachePath)
    }
}
