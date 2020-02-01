//
//  ScreenSize+Config.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
let IS_IPHONE_X = (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812) ||
    (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)

let SIZE_SCALE_Width: CGFloat = SCREEN_WIDTH / CGFloat(375.0)
let SIZE_SCALE_HEIGHT: CGFloat = (SCREEN_HEIGHT == 667.0 || IS_IPHONE_X) ? 1 : SCREEN_HEIGHT/CGFloat(667.0)
let SCREEN_SCALE = UIScreen.main.scale

let TAB_BAR_HEIGHT: CGFloat = IS_IPHONE_X ?  CGFloat(83.0) : CGFloat(49.0)
let TAB_IPHONEX_MARGIN: CGFloat = IS_IPHONE_X ? 34 : 0
let NAVIGATION_BAR_HHEIGHT: CGFloat = IS_IPHONE_X ? CGFloat(88.0) : CGFloat(64.0)
let STATUS_BAR_HEIGHT: CGFloat = IS_IPHONE_X ? CGFloat(44.0) : CGFloat(20.0)

let IS_IPHONE5 = SCREEN_HEIGHT == 568
let SAFE_AREA_INSETS = UIEdgeInsets(top: IS_IPHONE_X ? CGFloat(44.0):0, left: 0, bottom: IS_IPHONE_X ? CGFloat(34.0):0, right: 0)
let googleClearance = SCREEN_WIDTH == 320 ? 11 : (SCREEN_WIDTH == 375 ? 15 : 18)
let googleClearance1 = SCREEN_WIDTH == 320 ? 8 : (SCREEN_WIDTH == 375 ? 11 : 14)
let PLUS = SCREEN_HEIGHT == 736

//enum XSafeArea {
//    case left
//    case right
//    case top
//    case bottom
//    
//    var value: CGFloat {
//        if !IS_IPHONE_X { return 0 }
//        let isPortrait = !CRTAppDelegate.shared.isRotation
//        switch self {
//        case .left:
//            return isPortrait ? 0 : 44
//        case .right:
//            return isPortrait ? 0 : 34
//        case .top:
//            return isPortrait ? 44 : 0
//        case .bottom:
//            return isPortrait ? 34 : 21
//        }
//    }
//}
