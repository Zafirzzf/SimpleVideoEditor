//
//  MediaPickerViewController.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/26.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Photos

private let cellID = "cellID"
class MediaPickerViewController: UIViewController {
    
    typealias VideoPickCallback = (VideoPickItem) -> Void
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            let width: CGFloat = (SCREEN_WIDTH - 2 * 3) / 4
            $0.itemSize = CGSize(width: width, height: width)
            $0.minimumLineSpacing = 2
            $0.minimumInteritemSpacing = 2
    })
    
    private let videoAlbum = AssetAlbum()
    private let disposeBag = DisposeBag()
    private let assetCallback: VideoPickCallback
    private var requestId: PHImageRequestID?
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        requestId.on(PHImageManager.default().cancelImageRequest)
    }
    
    init(videoResultCallback: @escaping VideoPickCallback) {
        self.assetCallback = videoResultCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
    }
    
    static func checkPhotoLibraryPermission(hasPermissionHandler: @escaping VoidCallback) {
        let deniedHandler = {
            ZFAlertView(title: KeyString.pleaseOpenAlbumPermission*,
                        leftTitle: KeyString.confirm*,
                        rightTitle: KeyString.gotoSet*) { (isLeft) in
                            guard !isLeft else { return }
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
            }.show()
        }
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            hasPermissionHandler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        hasPermissionHandler()
                    } else {
                        deniedHandler()
                    }
                }
            }
        default:
            deniedHandler()
        }
    }
}

// MARK: - 事件
private extension MediaPickerViewController {
    func selectItem(of indexPath: IndexPath) {
        let item = videoAlbum.allItems.value[indexPath.row]
        HudManager.shared.showHud()
        requestId = item.loadVideo(progressHandler: { [weak self] (_, error) in
            if error != nil {
                HudManager.shared.showFailure(KeyString.loadError*)
            }
        }) { [weak self] (avAsset) in
            HudManager.shared.dismissHud()
            self?.assetCallback(VideoPickItem(asset: avAsset,
                                                size: [item.asset.pixelWidth.cg, item.asset.pixelHeight.cg]))
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - 配置UI
private extension MediaPickerViewController {
    func setupView() {
        collectionView.then {
            $0.delegate = self
            $0.backgroundColor = UIColor.blackLight
            view.addSubview($0)
            $0.register(VideoPickerCell.self, forCellWithReuseIdentifier: cellID)
            $0.snp.makeConstraints {
                $0.edges.equalTo(UIEdgeInsets.zero)
            }
            $0.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
                self.selectItem(of: indexPath)
            }).disposed(by: disposeBag)
        }
        videoAlbum.allItems.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: IndexPath(item: row, section: 0)) as! VideoPickerCell
                cell.update(with: element)
                return cell
        }.disposed(by: disposeBag)
    }
}

// MARK: - collectionView代理
extension MediaPickerViewController: UICollectionViewDelegate {
    
}
