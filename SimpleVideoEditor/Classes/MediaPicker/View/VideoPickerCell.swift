//
//  VideoPickerCell.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/26.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class VideoPickerCell: UICollectionViewCell {
    
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    private let bottomBackgroundView = UIView()
    private var theItem: AssetItem?
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBackgroundView.addGradientLayer(with: UIColor.blackBackground, direction: .bottom)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.nb
            .contentMode(.scaleAspectFill)
            .maskToBounds()
            .addToSuperView(contentView)
        addSubview(bottomBackgroundView)
        timeLabel.nb
            .textAlignment(.right)
            .font(13.fontMedium)
            .textColor(.white)
            .shadow(color: UIColor.black, opacity: 1, offset: .zero, radius: 3)
            .addToSuperView(contentView)
        imageView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets.zero)
        }
        bottomBackgroundView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints {
            $0.right.equalTo(-5)
            $0.bottom.equalTo(-3)
        }
        
    }
    
    func update(with item: AssetItem) {
        timeLabel.text = item.videoDurationText
        self.theItem = item
        imageView.image = nil
        item.loadThumbnailImage(targetWidth: bounds.width * UIScreen.main.scale) { [weak self] (image) in
            guard let self = self else {
                return
            }
            if self.theItem! == item {
                self.imageView.image = image
            }
        }
    }
}
