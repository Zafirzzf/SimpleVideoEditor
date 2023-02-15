//
//  ImageGenerator.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/6.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import AVFoundation


class ImageGenerator {
    static func generateThumbnailImages(with asset: AVAsset) -> [UIImage] {
        let duration = asset.duration.seconds
//        AVAssetImageGenerator(asset: <#T##AVAsset#>)
        print(duration)
        return []
    }
}
