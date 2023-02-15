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
    func pickMusic(of item: VideoPickItem, fileName: String, complete: @escaping VoidCallback) {
        let asset = item.asset
        let mixComposition = AVMutableComposition()
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            assertionFailure()
            return
        }
        do {
            try firstTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .audio).first!, at: .zero)
            guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else { return }
            exporter.outputURL = cacheAudioURL(of: fileName)
            exporter.outputFileType = .m4a
            exporter.shouldOptimizeForNetworkUse = true
            HudManager.shared.showHud()
            exporter.exportAsynchronously {
                DispatchQueue.main.async {
                    print(exporter.status.rawValue, "导出状态: ")
                    switch exporter.status {
                    case .completed:
                        HudManager.shared.showSuccessHud("导出完成，请前往设置中心查看".international)
                        complete()
                    case .failed:
                        HudManager.shared.showFailure("导出失败，请重试".international)
                    default:
                        break
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func cacheAudioURL(of name: String) -> URL? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH-mm"
        let cachePath = musicCacheDirectory + "/\(name).m4a"
        return URL(fileURLWithPath: cachePath)
    }
}
