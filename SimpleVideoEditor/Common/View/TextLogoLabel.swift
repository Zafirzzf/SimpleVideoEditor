//
//  TextLogoLabel.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/18.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class TextLogoLabel: UILabel {

    required init?(coder aDecoder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        self.nb.font(UIFont(name: "Helvetica-BoldOblique", size: 22)!)
            .text("Simple Player")
            .textColor(UIColor.black)
    }
}
