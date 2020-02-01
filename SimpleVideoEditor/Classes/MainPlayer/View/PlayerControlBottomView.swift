//
//  PlayerControlBottomView.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/27.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlayerControlBottomView: UIView {

    let playPauseButton = ZoomButton()
    let progressView = UISlider()
    let timeLabel = UILabel()
    let fullScreenButton = UIButton()
    
    let touchup = PublishRelay<Float>()
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubview(playPauseButton)
        progressView.then {
            $0.thumbTintColor = .white
            $0.minimumTrackTintColor = .white
            $0.addTarget(self, action: #selector(sliderTouchEnd(_:)), for: .touchUpOutside)
            $0.addTarget(self, action: #selector(sliderTouchEnd(_:)), for: .touchUpInside)
            $0.addTarget(self, action: #selector(sliderTouchEnd(_:)), for: .touchCancel)
        }
        addSubview(progressView)
        timeLabel.nb.font(12.font)
            .textColor(UIColor.white)
            .addToSuperView(self)
        fullScreenButton.nb
            .image("screen".toImage())
            .addToSuperView(self)
        playPauseButton.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        progressView.snp.makeConstraints {
            $0.left.equalTo(playPauseButton.snp.right).offset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(progressView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        fullScreenButton.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(timeLabel.snp.right).offset(8)
        }
    }
    
    @objc
    private func sliderTouchEnd(_ slider: UISlider) {
        touchup.accept(slider.value)
    }
}
