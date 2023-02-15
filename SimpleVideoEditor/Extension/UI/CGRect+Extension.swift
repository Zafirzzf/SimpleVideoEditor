//
//  CGRect+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

extension CGRect: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        guard elements.count == 4 else {
            fatalError("CGRect init elements count incorrect")
        }
        self.init(x: elements[0], y: elements[1], width: elements[2], height: elements[3])
    }
    
    public typealias ArrayLiteralElement = CGFloat
}

extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        guard elements.count == 2 else {
            fatalError()
        }
        self = CGSize(width: elements[0], height: elements[1])
    }
}

extension CGRect {
    
    var originX: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self = CGRect(x: newValue, y: self.minY, width: self.sizeWidth, height: self.sizeHeight)
        }
    }
    
    var originY: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self = CGRect(x: self.originX, y: newValue, width: self.sizeWidth, height: self.sizeHeight)
        }
    }
    
    var sizeWidth: CGFloat {
        get {
            return self.size.width
        }
        set {
            self = CGRect(x: self.originX, y: self.minY, width: newValue, height: self.sizeHeight)
        }
    }
    
    var sizeHeight: CGFloat {
        get {
            return self.size.height
        }
        set {
            self = CGRect(x: self.originX, y: self.minY, width: self.sizeWidth, height: newValue)
        }
    }
    
    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            originY = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            self = CGRect(x: originX, y: newValue - sizeHeight, width: sizeWidth, height: sizeHeight)
        }
    }
    
    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.originX = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return originX + sizeWidth
        }
        set {
            self = CGRect(x: newValue - sizeWidth, y: originY, width: sizeWidth, height: sizeHeight)
        }
    }
    
    var midX: CGFloat {
        get {
            return self.originX + self.sizeWidth / 2
        }
        set {
            self = CGRect(x: newValue - sizeWidth / 2, y: originY, width: sizeWidth, height: sizeHeight)
        }
    }
    
    var midY: CGFloat {
        get {
            return self.originY + self.sizeHeight / 2
        }
        set {
            self = CGRect(x: originX, y: newValue - height / 2, width: sizeWidth, height: sizeHeight)
        }
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.minY)
        }
        set {
            self = CGRect(x: newValue.x - sizeWidth / 2, y: newValue.y - sizeHeight / 2, width: sizeWidth, height: sizeHeight)
        }
    }
}
