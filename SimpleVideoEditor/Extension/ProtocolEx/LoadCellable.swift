//
//  LoadCellable.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import UIKit

protocol LoadCellable where Self: UITableViewCell {
    
}

extension UITableViewCell: LoadCellable { }

extension LoadCellable  {
    static func cellWithTableView(_ tableView: UITableView) -> Self {
        let cellID = NSStringFromClass(self).components(separatedBy: ".").last!
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? Self
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? Self)
        }
        return cell!
    }
    
    static func cellWithTableViewFromCode(_ tableView: UITableView) -> Self {
        let cellID = NSStringFromClass(self).components(separatedBy: ".").last!
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? Self
        if cell == nil {
            cell = self.init(style: .default, reuseIdentifier: cellID)
        }
        return cell!
    }
}
