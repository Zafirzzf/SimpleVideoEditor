//
//  PhotoLibraryManager.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/29.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import Photos

class PhotoLibraryManager {
    private enum RequestType {
        case image(UIImage)
        case imageURL(URL)
        case videoURL(URL)
    }
    static func saveImageToAlbum(with image: UIImage, completion: BoolCallback? = nil) {
        saveMediaToAblum(by: .image(image), completion: { success in
            DispatchQueue.main.async {
                completion?(success)
            }
        })
    }
    
    static func saveImageToAlbum(with imageURL: URL, completion: BoolCallback? = nil) {
        saveMediaToAblum(by: .imageURL(imageURL), completion: { success in
            DispatchQueue.main.async {
                completion?(success)
            }
        })
    }
    
    static func saveVideoToAblum(with videoURL: URL, completion: BoolCallback? = nil) {
        saveMediaToAblum(by: .videoURL(videoURL), completion: { success in
            DispatchQueue.main.async {
                completion?(success)
            }
        })
    }
    
    private static func saveMediaToAblum(by requestType: RequestType, completion: BoolCallback? = nil) {
        guard let alohaCollection = projectAlbumCollection else {
            completion?(false)
            return
        }
        PHPhotoLibrary.shared().performChanges({
            let request: PHAssetChangeRequest?
            switch requestType {
            case .image(let image):
                request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            case .imageURL(let imageURL):
                request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
            case .videoURL(let videoURL):
                request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }
            guard let placeholder = request?.placeholderForCreatedAsset else {
                completion?(false)
                return
            }
            let photosAsset = PHAsset.fetchAssets(in: alohaCollection, options: nil)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: alohaCollection, assets: photosAsset) else {
                completion?(false)
                return
            }
            albumChangeRequest.addAssets([placeholder] as NSFastEnumeration)
        }, completionHandler: { success, error in
            completion?(success)
        })
    }
    
    private static var projectAlbumCollection: PHAssetCollection? {
        let title = "SimpleVideo"
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        var localIdentifier = ""
        var alohaCollection: PHAssetCollection?
        if let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions).firstObject {
            alohaCollection = collection
        } else {
            PHPhotoLibrary.shared().performChanges({
                let req = PHAssetCollectionChangeRequest
                    .creationRequestForAssetCollection(withTitle: title)
                localIdentifier = req.placeholderForCreatedAssetCollection.localIdentifier
            }, completionHandler: { _, _ in
                let collectionResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [localIdentifier], options: nil)
                alohaCollection = collectionResult.firstObject
            })
        }
        return alohaCollection
    }
}
