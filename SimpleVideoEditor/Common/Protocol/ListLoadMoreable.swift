//
//  ListLoadMoreable.swift
//  HappyBonus
//
//  Created by 周正飞 on 2019/1/4.
//  Copyright © 2019年 MIX. All rights reserved.
//

import Foundation

/// 抽象了加载更多与重新加载的逻辑
protocol ListLoadMoreable: class {
    var cursor: Int { get set }
    var hasMore: Bool { get set }
    func loadListData()
    func pullToRefreshAction()
    func loadMoreRefreshAction()
}

extension ListLoadMoreable {
    /// 下拉刷新
    func pullToRefreshAction() {
        cursor = 0
        loadListData()
    }
    
    /// 上拉加载
    func loadMoreRefreshAction() {
        guard hasMore else {
            return
        }
        cursor += 1
        loadListData()
    }
}
