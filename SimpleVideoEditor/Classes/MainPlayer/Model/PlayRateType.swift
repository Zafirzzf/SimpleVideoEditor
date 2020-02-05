//
//  PlayRateType.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/30.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

enum PlayRateType: Float, CaseIterable {
    case normal = 1
    case eightTenths = 0.8
    case half = 0.5
    case slowest = 0.25
    
    func toggle() -> PlayRateType {
        switch self {
        case .normal:
            return .eightTenths
        case .eightTenths:
            return .half
        case .half:
            return .slowest
        case .slowest:
            return .normal
        }
    }
    
    static var rateTitles: [String] { allCases.map { $0.rawValue.description } }
}
