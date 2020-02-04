//
//  KeyString.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/4.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

enum KeyString {
    static let confirm = "确认"
    static let cancel = "取消"
    static let save = "保存"
    static let gotoSet = "去设置"
    static let loadError = "加载出错"
    static let selectVideo = "选择视频"
    static let mirror = "镜像"
    static let exportVideo = "导出视频"
    static let exportFail = "导出失败"
    static let saveMirrorText = "将以镜像的状态保存视频，是否继续"
    
    static let mainIntroducation = "简单易用的视频播放器\n 镜像/慢速 \n 可保存到本地"
    static let moreFeatureIntroducation = "更多功能敬请期待..."
    static let pleaseOpenAlbumPermission = "请先开启相册权限已选择视频"
    
    
}

postfix operator *
postfix func *(right: String) -> String {
    NSLocalizedString(right, comment: right)
}
