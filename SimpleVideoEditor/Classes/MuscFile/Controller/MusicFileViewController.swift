//
//  MusicFileViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/4/19.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class MusicFileViewController: BaseViewController {

    lazy var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVIGATION_BAR_HHEIGHT))
    
    let disposeBag = DisposeBag()
    private lazy var vm = MusicFileVM(player: self.player)
    let player = AVPlayer()
    
    deinit {
        player.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registTableViewReloadObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigation()
    }
}


// MARK: - 基础配置
private extension MusicFileViewController {
    func setup() {
        title = "提取的音乐".international
        view.backgroundColor = UIColor.blackLight
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        vm.output.currentMusic.subscribe(onNext: { [unowned self] in
            $0.on {
                self.player.replaceCurrentItem(with: AVPlayerItem(url: URL(fileURLWithPath: $0.path)))
                self.player.play()
            }
        }).disposed(by: disposeBag)
        vm.playState.asDriver()
            .drive(player.rx.playState)
            .disposed(by: disposeBag)
        
        let bottom = PlayerControlBottomView()
        vm.controlVM.output.playPauseIcon
            .drive(bottom.playPauseButton.rx.image())
            .disposed(by: disposeBag)
        vm.controlVM.output.progress
            .drive(bottom.progressView.rx.value)
            .disposed(by: disposeBag)
        vm.controlVM.output.timeFormate
            .drive(bottom.timeLabel.rx.text)
            .disposed(by: disposeBag)
        vm.controlVM.output.fullScreenHidden
            .drive(bottom.fullScreenButton.rx.isHidden)
            .disposed(by: disposeBag)
        bottom.playPauseButton.rx.tap
            .bind(to: vm.controlVM.input.playOrPause)
            .disposed(by: disposeBag)
        bottom.progressView.rx.value
            .bind(to: vm.controlVM.input.dragProgress)
            .disposed(by: disposeBag)
        bottom.touchup.bind(to: vm.controlVM.input.sliderTouchup)
            .disposed(by: disposeBag)
        view.addSubview(bottom)
        bottom.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(50)
        }
    }
}


extension MusicFileViewController: SingleTableViewProtocol {
    var models: BehaviorRelay<[MusicItem]?> {
        vm.output.models
    }
    typealias CellType = MusicItemCell
    
    func selectTableViewCell(of indexPath: IndexPath, model: MusicItem) {
        vm.input.selectMusic.accept(model)
        vm.output.currentMusic.accept(model)
    }
}

