//
//  ITableView.swift
//  MVVMDemo
//
//  Created by 周正飞 on 2018/5/7.
//  Copyright © 2018年 周正飞. All rights reserved.
//

import UIKit

/// TableView相关
protocol ITableViewRelated {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func heightForHeader(in section: Int) -> CGFloat
    func viewForHeader(in section: Int) -> UIView?
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
    func viewForFooter(in section: Int) -> UIView?
    func heightForFooter(in secion: Int) -> CGFloat
}

extension ITableViewRelated {
    func numberOfSections() -> Int { return 0 }
    func numberOfRows(in section: Int) -> Int { return 0 }
    func heightForHeader(in section: Int) -> CGFloat { return 0 }
    func viewForHeader(in section: Int) -> UIView? { return nil}
    func heightForRow(at indexPath: IndexPath) -> CGFloat { return 0 }
    func didSelectRow(at indexPath: IndexPath) {}
    func viewForFooter(in section: Int) -> UIView? { return nil }
    func heightForFooter(in section: Int) -> CGFloat { return 0 }
}
