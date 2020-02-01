//
//  ExportViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/1.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit

class ExportViewController: BaseViewController {

    private var progressMaker: FakeProgressMaker!
    private let finishImageV = UIImageView(image: "finish".toImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "导出视频".international
        finishImageV.alpha = 0
        view.addSubview(finishImageV)
        let progressView = UIProgressView(progressViewStyle: .bar).then {
            $0.trackTintColor = UIColor.lightGray
            $0.progressTintColor = .subject
            view.addSubview($0)
        }
        let textLabel = UILabel().nb
            .font(20.fontMedium)
            .textColor(UIColor.white)
            .addToSuperView(self.view).base
        textLabel.snp.makeConstraints {
            $0.bottom.equalTo(progressView.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
        }
        progressView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(12)
        }
        finishImageV.snp.makeConstraints {
            $0.bottom.equalTo(textLabel.snp.top).offset(-50)
            $0.centerX.equalToSuperview()
        }
        progressMaker = FakeProgressMaker(target: self) { (progress) in
            progressView.progress = progress
            textLabel.text = String(format: "%02d", Int(progress * 100)) + "%"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func finish(success: Bool) {
        if success {
            progressMaker.finish()
            showFinishIcon()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.pop()
            }
        } else {
            HudManager.shared.showText("导出失败".international)
            pop()
        }
    }
    
    private func showFinishIcon() {
        UIView.animate(withDuration: 0.25, animations: {
            self.finishImageV.alpha = 1
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
