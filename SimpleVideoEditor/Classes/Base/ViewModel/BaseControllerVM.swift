//
//  BaseControllerVM.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/28.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation

/// ViewController对应VM的通用方法, 避免重复声明方法.
protocol BaseControllerVM: ITableViewRelated {
    
    // MARK: 声明周期相关
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

extension BaseControllerVM {
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewWillDisappear() { }
    func viewDidDisappear()  { }

}
