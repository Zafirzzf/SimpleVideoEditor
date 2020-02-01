//
//  AssetItem.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/26.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import Photos

struct AssetItem {
    let asset: PHAsset
    
    let videoDuration: Double
    let videoDurationText: String
    
    init(asset: PHAsset) {
        self.asset = asset
        self.videoDuration = asset.duration
        let minutes = Int(asset.duration / 60)
        let seconds = Int(asset.duration.truncatingRemainder(dividingBy: 60))
        self.videoDurationText = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func loadThumbnailImage(targetWidth: CGFloat, complete: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions().then {
            $0.resizeMode = .fast
            $0.isNetworkAccessAllowed = true
            $0.version = .current
        }
        PHImageManager.default()
            .requestImage(for: asset,
                          targetSize: CGSize(width: targetWidth, height: targetWidth),
                          contentMode: .aspectFill,
                          options: options) { (image, info) in
                            complete(image)
        }
    }
    
    func loadVideo(progressHandler: @escaping (Double, AssetDownloadError?) -> Void,
                   resultHandler: @escaping (AVAsset) -> Void) -> PHImageRequestID {
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .mediumQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, info) in
            DispatchQueue.main.async {
                let downloadError: AssetDownloadError? = (error as NSError?).flatMap {
                    return $0.isICloudFetchFailure ? .cloudFetchFailure : nil
                }
                progressHandler(progress, downloadError)
            }
        }
        return PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (videoAsset, _, _) in
            guard let videoAsset = videoAsset else {
                return
            }
            DispatchQueue.main.async {
                resultHandler(videoAsset)
            }
        }
    }
    
    static func == (lhs: AssetItem, rhs: AssetItem) -> Bool {
        return lhs.asset == rhs.asset
    }
}

enum AssetDownloadError: Error {
    case cloudFetchFailure
    case downloadFailure
    case cacheFailure
    case other
    
    var localizedDescription: String {
        switch self {
        case .cloudFetchFailure:
            return "从iCloud同步数据失败".international
        default:
            return "获取图片失败，请重试".international
        }
    }
}

private extension NSError {
    var isICloudFetchFailure: Bool {
        return self.domain == "CloudPhotoLibraryErrorDomain"
    }
}
