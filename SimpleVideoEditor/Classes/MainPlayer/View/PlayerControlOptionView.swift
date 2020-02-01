//
//  PlayerControlOptionView.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/29.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import RxCocoa

class PlayerControlOptionView: UIView {

    required init?(coder aDecoder: NSCoder) { nil }
    
    let mirrorButton = ZoomButton(position: .top)
    let rateButton = ZoomButton(position: .top)
    
    let mirrorTap = PublishRelay<Void>()
    let rateSelect = PublishRelay<Void>()
    
    init() {
        super.init(frame: .zero)
        mirrorButton.nb
            .title("镜像".international)
            .font(11.fontMedium)
            .titleColor(UIColor.white)
            .titleColor(UIColor.subject, state: .selected)
            .image("mirror_normal".toImage())
            .image("mirror_sel".toImage(), state: .selected)
            .addToSuperView(self)
            .whenTap { [unowned self] in
                self.mirrorTap.accept(())
        }
        
        rateButton.nb.image("slowPlay_normal".toImage())
            .image("slowPlay_sel".toImage(), state: .selected)
            .font(11.fontMedium)
            .titleColor(UIColor.white)
            .titleColor(UIColor.subject, state: .selected)
            .addToSuperView(self)
        rateButton.addTouch { [unowned self] in
            self.rateSelect.accept(())
        }
        
        mirrorButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-40)
        }
        rateButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(40)
        }
    }
    
}
