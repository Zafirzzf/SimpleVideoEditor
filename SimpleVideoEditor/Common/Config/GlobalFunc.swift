//
//  GlobalFunc.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//


/// 全局函数
import Foundation

func debugLog<T>(_ message:T, file:String = #file, function:String = #function,
                        line:Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):\(line) \(function) | \(message)")
    #endif
}

/// 某一实例的类名
func classString(from instance: AnyObject) -> String {
    return NSStringFromClass(type(of: instance))
}

/// 计算函数时间
func functionSpendTime(block: () -> ()) -> Double {
    let start = CFAbsoluteTimeGetCurrent()
    block()
    let end = CFAbsoluteTimeGetCurrent()
    print(end - start)
    return end - start
}

/// 主线程异步延迟
func after(time: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: execute)
}
