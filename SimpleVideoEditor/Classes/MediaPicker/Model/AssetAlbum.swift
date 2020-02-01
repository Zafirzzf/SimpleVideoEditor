//
//  VideoAlbum.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/26.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import RxCocoa

class AssetAlbum {
    let allItems = BehaviorRelay<[AssetItem]>(value: [])

    init() {
        DispatchQueue.global().async {
            let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
            albums.enumerateObjects(options: .concurrent) { (collection, _, _) in
                guard collection.assetCollectionSubtype == .smartAlbumUserLibrary else { return }
                let assetsResult = PHAsset.fetchAssets(in: collection,
                                                       options: PHFetchOptions().then {
                    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    $0.predicate = NSPredicate(format: "mediaType == %i", PHAssetMediaType.video.rawValue)
                })
                let items = (0 ..< assetsResult.count)
                    .map { assetsResult.object(at: $0) }
                    .map(AssetItem.init)
                DispatchQueue.main.async {
                    self.allItems.accept(items)
                }
            }
        }
    }
}
