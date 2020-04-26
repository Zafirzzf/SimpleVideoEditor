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
    
    let mirrorButton = OptionButton(position: .top)
    let rateButton = OptionButton(position: .top)
    let musicButton = OptionButton(position: .top)
    
    let mirrorTap = PublishRelay<Void>()
    let rateSelect = PublishRelay<Void>()
    let musicTap = PublishRelay<Void>()
    
    init() {
        super.init(frame: .zero)
        mirrorButton.nb
            .title(KeyString.mirror*)
            .image("mirror_normal".toImage())
            .image("mirror_sel".toImage(), state: .selected)
            .addToSuperView(self)
            .whenTap { [unowned self] in
                self.mirrorTap.accept(())
        }
        rateButton.nb.image("slowPlay_normal".toImage())
            .image("slowPlay_sel".toImage(), state: .selected)
            .addToSuperView(self)
            .whenTap { [unowned self] in
                self.rateSelect.accept(())
        }
        musicButton.nb.title("提取音乐".international)
            .image("music_normal".toImage(), "music_sel".toImage())
            .addToSuperView(self)
            .whenTap {
                self.musicTap.accept(())
        }
        let stackView = UIStackView(arrangedSubviews: [mirrorButton, rateButton, musicButton])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

class OptionButton: ZoomButton {
    required init?(coder aDecoder: NSCoder) { nil }
    
    init(position: CustomImagePositionButton.ImagePosition) {
        super.init(position: position, frame: .zero)
        nb.font(11.fontMedium)
            .titleColor(UIColor.white)
            .titleColor(UIColor.subject, state: .selected)
    }
}
