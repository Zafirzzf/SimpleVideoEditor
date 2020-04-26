//
//  MusicItem.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/19.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

struct MusicItem {
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    var name: String {
        path.components(separatedBy: "/").last ?? ""
    }
}
