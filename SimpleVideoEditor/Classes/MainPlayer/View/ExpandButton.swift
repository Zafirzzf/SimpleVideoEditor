//
//  ExpandButton.swift
//  kLineTest
//
//  Created by 周正飞 on 2018/6/16.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

/// 展开按钮相关定制
class ExpandButtonStyle {
    /// 展开方向
    var isExpandUp = false
    /// 背景颜色
    var backgroundColor: UIColor?
    /// 标题之间的横线颜色(无就没有线)
    var titleMarginLineColor: UIColor?
    /// 标题普通颜色
    var titleColor = UIColor.white.withAlphaComponent(0.8)
    /// 标题选中颜色
    var titleSelColor = UIColor.subject
    /// 第一个标题与父视图之间距离(用于特殊气泡情况)
    var firstTilteMargin: CGFloat = 0
    /// 一个标题的高度
    var titleHeight: CGFloat = 32
    /// 是否有气泡背景
    var bubbleBackground = false
    /// 标题们的字体
    var titleFont: UIFont = 16.fontMedium
    /// 容器Y轴偏移
    var contentOffsetY: CGFloat = 0
    /// 菜单里文字选中是否颜色区分
    var listItemHighlightWhenSel = false
    /// 菜单里超过多少个标题开始滚动
    var maxTitleContentCount = 8.8
}

/// 点击后可展开的Button
class ExpandButton: ZoomButton {

    /// 展开后字符数组
    var expandTitles: [String]
    var subButtons = [UIButton]()
    var bubbleImageV = UIImageView()
    var style: ExpandButtonStyle
    let expandContainer = UIScrollView()
    var fullScreenContainer = UIView(frame: UIScreen.main.bounds)
    var itemClickCallback: IntCallback?
    /// 控制是否展开
    var isExpand = false {
        didSet {
            if isExpand {
                resetContainerFrame()
                UIApplication.shared.keyWindow!.addSubview(fullScreenContainer)
            } else {
                fullScreenContainer.removeFromSuperview()
            }
        }
    }
    
    init(frame: CGRect = CGRect.zero,
         titles: [String] = [],
         expandStyle: ExpandButtonStyle = ExpandButtonStyle(),
         position: CustomImagePositionButton.ImagePosition) {
        self.style = expandStyle
        self.expandTitles = titles
        super.init(position: position, frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.style = ExpandButtonStyle()
        self.expandTitles = [String]()
        super.init(coder: aDecoder)
    }
    
    /// 对外提供
    func resetTitles(_ titles: [String]) {
        self.isSelected = false
        self.isExpand = false
        self.expandTitles = titles
        resetAllView()
        setup()
    }
    
    /// 重新布局(针对从xib中不知道frame的情况)
    func reLayout() {
        setupFrameAndTitles()
    }
    
    func resetStyle(_ style: ExpandButtonStyle) {
        self.style = style
        resetAllView()
        setup()
    }
    
    /// 让某一button处于选中状态
    func selectedButton(of index: Int?) {
        guard let index = index else { return }
        subButtons[index].isSelected = true
    }
}

// MARK: - 初始UI
extension ExpandButton {
    func setup() {
        titleLabel?.adjustsFontSizeToFitWidth = true
        fullScreenContainer.whenTap { [weak self]  (_) in
            self?.isExpand = false
        }
        fullScreenContainer.addSubview(expandContainer)
        expandContainer.backgroundColor = style.backgroundColor
        expandContainer.indicatorStyle = .white
        
        expandTitles.forEach { _ in
           let button = UIButton(type: .custom).nb
                .font(style.titleFont).base
            setupCommonStyle(button)
            subButtons.append(button)
            expandContainer.addSubview(button)
            button.addTarget(self, action: #selector(buttonItemClick(_:)), for: .touchUpInside)
        }
        /// 添加气泡背景
        if style.bubbleBackground {
            bubbleImageV.image = "btn_jy_zk".toImage()
            bubbleImageV.frame = expandContainer.bounds
            expandContainer.addSubview(bubbleImageV)
            expandContainer.sendSubviewToBack(bubbleImageV)
            if !style.isExpandUp {
                bubbleImageV.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        }
        setupFrameAndTitles()
    }
    
    func setupFrameAndTitles() {
        expandContainer.subviews.filter {$0.height == 1}.forEach {$0.removeFromSuperview()}
        let titles = expandTitles
        for (i, button) in subButtons.enumerated() {
            button.setTitle(titles[i], for: .normal)
            var buttonY: CGFloat = 0
            if style.isExpandUp {
                buttonY = (style.titleHeight + (style.titleMarginLineColor == nil ? 0 : 1)) * i.cg
            } else {
                buttonY = style.firstTilteMargin + (style.titleHeight + (style.titleMarginLineColor == nil ? 0 : 1)) * i.cg
            }
            button.frame = [0, buttonY, bounds.width, style.titleHeight]
            if i != subButtons.count - 1 {
                if let lineColor = style.titleMarginLineColor {
                    let lineView = UIView(frame: CGRect(x: 12, y: button.maxY, width: bounds.width - 24, height: 1))
                    lineView.backgroundColor = lineColor
                    expandContainer.addSubview(lineView)
                }
            }
            if i == subButtons.count - 1 {
                var expandContainerH = button.maxY + (style.isExpandUp ? style.firstTilteMargin : 0)
                let expandBtnFrameOfWindow = self.convert(CGRect(origin: .zero, size: self.size), to: UIWindow.keyWindow)
                // 如果container高度超过一定范围, 添加滚动效果
                if expandContainerH > style.titleHeight * style.maxTitleContentCount.cg {
                    expandContainer.contentSize = CGSize(width: self.width, height: expandContainerH)
                    expandContainerH = style.titleHeight * style.maxTitleContentCount.cg
                } else {
                    expandContainer.contentSize = CGSize(width: self.width, height: expandContainerH)
                }
                expandContainer.frame = [
                    expandBtnFrameOfWindow.minX,
                    style.isExpandUp ? expandBtnFrameOfWindow.minY - expandContainerH : expandBtnFrameOfWindow.maxY,
                    bounds.width,
                    expandContainerH
                ]
                bubbleImageV.frame = expandContainer.bounds
                /// Y轴偏移
                expandContainer.frame.origin.y = expandContainer.frame.origin.y + style.contentOffsetY
            }
        }
    }
    
    @objc func buttonItemClick(_ button: UIButton) {
        isExpand = false
        subButtons.forEach { $0.isSelected = false }
        if style.listItemHighlightWhenSel {
            button.isSelected = true
        }
        guard let index = subButtons.firstIndex(where: {$0 == button}) else { return }
        itemClickCallback?(index)
    }
    
    // 点击时候获取弹出框的位置
    func resetContainerFrame() {
        guard let superView = superview else { return }
        let layoutPoint = superView.convert(self.frame, to: UIApplication.shared.keyWindow!)
        if style.isExpandUp {
            expandContainer.frame.origin = CGPoint(x: layoutPoint.minX, y: layoutPoint.minY - expandContainer.height)
        } else {
            expandContainer.frame.origin = CGPoint(x: layoutPoint.minX, y: layoutPoint.maxY)
        }
    }
    
    func setupCommonStyle(_ button: UIButton) {
        button.setTitleColor(style.titleSelColor, for: .selected)
        button.setTitleColor(style.titleColor, for: .normal)
        button.backgroundColor = style.backgroundColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func resetAllView() {
        expandContainer.subviews.forEach { $0.removeFromSuperview() }
        subButtons = []
    }
}

extension ExpandButtonStyle {
    /// 朝下带横线气泡
    static var down: ExpandButtonStyle {
        let style = ExpandButtonStyle()
        style.bubbleBackground = true
        style.firstTilteMargin = 5
        style.titleFont = 12.fontMedium
        style.contentOffsetY = 0
        style.titleMarginLineColor = UIColor.white.withAlphaComponent(0.1)
        return style
    }
    /// 朝上带横线气泡
    static var up: ExpandButtonStyle {
        let style = ExpandButtonStyle()
        style.isExpandUp = true
        style.bubbleBackground = true
        style.firstTilteMargin = 10
        style.titleFont = 12.fontMedium
        style.contentOffsetY = 0
        style.titleMarginLineColor = UIColor.white.withAlphaComponent(0.1)
        return style
    }
    
    /// 朝下筛选交易对的风格
    static var filterSymbolStyle: ExpandButtonStyle {
        let style = ExpandButtonStyle()
        style.backgroundColor = UIColor.blackLight
        //修改横线颜色
        style.titleMarginLineColor = UIColor.white.withAlphaComponent(0.1)
        //修改标题颜色
        style.titleColor = UIColor.white.withAlphaComponent(0.8)
        style.titleHeight = 44
        style.firstTilteMargin = 0
        style.listItemHighlightWhenSel = true
        return style
    }
}

