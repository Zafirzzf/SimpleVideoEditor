//
//  VideoPickResult.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import AVFoundation

struct VideoPickItem {
    
    let asset: AVAsset
    let size: CGSize
    
    var isHorizontal: Bool { size.width > size.height }
    
    func videoHeight(from width: CGFloat) -> CGFloat {
        width / size.width * size.height
    }
}
