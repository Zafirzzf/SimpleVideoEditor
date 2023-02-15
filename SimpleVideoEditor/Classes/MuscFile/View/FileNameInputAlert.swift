//
//  FileNameInputAlert.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/6/23.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FileNameInputAlert: UIView, AlertProtocol {
    
    private let inputTextCallback: StringCallback
    private let textField = UITextField()
    private let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    init(textCallback: @escaping StringCallback) {
        self.inputTextCallback = textCallback
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        backgroundColor = .blackLight
        textField.attributedPlaceholder = "请输入音乐名".international.attributeString(with: 13.fontMedium, color: .white)
        textField.textColor = .white
        addSubview(textField)
        let confirmButton = UIButton().nb.title("确认".international)
            .titleColor(.white)
            .backgroundImage(UIImage(color: UIColor.subject))
            .addToSuperView(self)
            .whenTap { [unowned self] in
                guard let input = self.textField.text else { return }
                self.inputTextCallback(input)
                self.dismiss()
        }
        .base
        textField.rx.text.map { !($0?.isEmpty ?? true) }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        textField.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(8)
            $0.right.equalTo(-8)
            $0.height.equalTo(50)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
}
