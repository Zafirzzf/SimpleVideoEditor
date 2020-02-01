//
//  AbnormalViewState.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/12/13.
//  Copyright © 2018年 MIX. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit

/// 缺省页类型, 添加类型补充info即可
enum AbnormalViewState {
    case normal
    case serviceLost
    case empty
    
    var info: (msg: String, image: UIImage) {
        switch self {
        case .empty:
            return ("当前页面没有内容哦...", UIImage(named: "emptyIcon")!)
        default:
            return ("", UIImage())
        }
    }
}

protocol AbnormalViewable {
    
}

extension UIView: AbnormalViewable { }
extension AbnormalViewable where Self: UIView {
    func setState(_ state: AbnormalViewState) {
        switch state {
        case .normal:
            subviews.first(where: {$0 is AbnormalView })?.removeFromSuperview()
        default:
            guard !subviews.contains(where: { $0 is AbnormalView }) else { return }
            self.addSubview(AbnormalView(frame: self.bounds, info: state.info))
        }
    }
}
extension AbnormalViewable where Self: UITableView {
    func setState(_ state: AbnormalViewState) {
        switch state {
        case .normal:
            subviews.first(where: {$0 is AbnormalView })?.removeFromSuperview()
        default:
            guard !subviews.contains(where: { $0 is AbnormalView }) else { return }
            /// 覆盖视图会露出headerView
            let frame: CGRect = [0, tableHeaderView?.maxY ?? 0, self.width, self.height - (tableHeaderView?.height ?? 0)]
            self.addSubview(AbnormalView(frame: frame, info: state.info))
        }
    }
}

extension UIViewController: AbnormalViewable { }
extension AbnormalViewable where Self: UIViewController {
    func setState(_ state: AbnormalViewState) {
        self.view.setState(state)
    }
}

extension Reactive where Base: UIView {
    var viewState: Binder<AbnormalViewState> {
        return Binder(self.base, binding: { (view, state) in
            (view as UIView).setState(state)
        })
    }
}
extension Reactive where Base: UITableView {
    var viewState: Binder<AbnormalViewState> {
        return Binder(self.base, binding: { (view, state) in
            (view as UITableView).setState(state)
        })
    }
}


/// 缺省视图的类型
class AbnormalView: UIView {
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    let imageView = UIImageView()
    let messageLabel = UILabel()
    
    init(frame: CGRect, info: (String, UIImage)) {
        super.init(frame: frame)
        setup()
        backgroundColor = .white
        messageLabel.text = info.0
        imageView.image = info.1
    }
    
    func setup() {
        imageView.nb
            .addToSuperView(self)
        messageLabel.nb.font(15.font)
            .textColor(UIColor.lightGray)
            .textAlignment(.center)
            .addToSuperView(self)
        // 布局
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
