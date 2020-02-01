//
//  MediaTool.swift
//  SeekLightActor
//
//  Created by 周正飞 on 2019/11/27.
//  Copyright © 2019 周正飞. All rights reserved.
//

import Foundation
import AVFoundation

class MediaTool {
    static func compressVideo(of url: URL, complete: @escaping (URL) -> Void) {
        guard let export = AVAssetExportSession(asset: AVAsset(url: url), presetName: AVAssetExportPresetMediumQuality) else { return }
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "/" + Date.BeiJingDate.description + "mp4")
        export.outputURL = outputURL
        export.shouldOptimizeForNetworkUse = true
        export.outputFileType = .some(.mp4)
        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                case .exporting:
                    HudManager.shared.showHud()
                case .failed:
                    print("压缩视频失败")
                    fallthrough
                case .cancelled:
                    print("取消压缩")
                    fallthrough
                case .completed:
                    print("压缩视频成功")
                    complete(outputURL)
                    fallthrough
                default:
                    HudManager.shared.dismissHud()
                }
            }
        }
    }
}
