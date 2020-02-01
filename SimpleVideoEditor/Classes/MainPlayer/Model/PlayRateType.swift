//
//  PlayRateType.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/30.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

enum PlayRateType: Float, CaseIterable {
    case slowest = 0.25
    case half = 0.5
    case eightTenths = 0.8
    case normal = 1
    
    func toggle() -> PlayRateType {
        switch self {
        case .slowest:
            return .half
        case .half:
            return .eightTenths
        case .eightTenths:
            return .normal
        case .normal:
            return .slowest
        }
    }
    
    static var rateTitles: [String] { allCases.map { $0.rawValue.description } }
}
