//
//  UIImage+Extension.swift
//  HappyBonus
//
//  Created by 周正飞 on 2018/11/26.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit
import Photos

extension UIImage {
    
    /// 生成某一个颜色的图片
     convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
    /// 生成一张渐变色图片
    static func graident(colors: [CGColor], size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        let colorSpace = colors.last!.colorSpace!
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)
        let start = CGPoint.zero
        let end = CGPoint(x: size.width, y: 0)
        context.drawLinearGradient(gradient!, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context.restoreGState()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 重绘一张指定尺寸的图
    func compressAlignedImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let frame = CGRect(origin: CGPoint(), size: size)
        draw(in: frame)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    /// 重绘一张图
    func redrawImage() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        draw(in: rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    //切圆角
    func circularImage(size: CGSize, backColor: UIColor, roundColor: UIColor? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let rect = CGRect(origin: CGPoint(), size: size)
        //填充背景色
        backColor.setFill()
        UIRectFill(rect)
        //切圆角
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)
        //加圆框
        if let roundColor = roundColor {
            path.lineWidth = 3
            roundColor.setStroke()
            path.stroke()
        }
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    /// 改变图片颜色
    func changeTintColor(with tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        if let tintImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return tintImage
        } else {
            UIGraphicsEndImageContext()
            return self
        }
    }
    
    /// 通过base64字符串创建Image
    convenience init?(base64String: String) {
        var baseString = base64String
        if baseString.hasPrefix("data:image") {
            guard let newBase64String = baseString.components(separatedBy: ",").last else {
                return nil
            }
            baseString = newBase64String
        }
        guard let imgData = Data(base64Encoded: baseString, options: .init(rawValue: 0)) else { return nil }
        self.init(data: imgData)
    }
    
    /**
     图片合成文字
     @param text            文字
     @param fontSize        字体大小
     @param textColor       字体颜色
     @param textFrame       字体位置
     @param image           原始图片
     @param viewFrame       图片所在View的位置
     @return UIImage *
     */
    func imageAddText(text: String,
                      textFont: CGFloat,
                      textColor: UIColor,
                      textFrame: CGRect,
                      originImage: UIImage,
                      imageLocationViewFrame:CGRect) -> UIImage {
        
        if text.isEmpty {
            return originImage
        }
        
        UIGraphicsBeginImageContext(imageLocationViewFrame.size)
        originImage.draw(in: CGRect(x: 0, y: 0, width: imageLocationViewFrame.size.width, height: imageLocationViewFrame.size.height))
        
        //设置添加文案的属性
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textFont), NSAttributedString.Key.foregroundColor: textColor]
        let markStr: NSString = text as NSString
        markStr.draw(in: CGRect(x: textFrame.origin.x, y: textFrame.origin.y, width: textFrame.size.width, height: textFrame.size.height), withAttributes: attributes)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     图片上绘制图片
     @param sourceImage     底图图片
     @param addImage        需要添加的图片
     @return UIImage *
     */
    func imageAddImage(sourceImage: UIImage,
                       addImage: UIImage) -> UIImage {
        let sourceImageWidth = sourceImage.size.width
        let sourceImageHeight = sourceImage.size.height
        // 开始给图片添加图片
        UIGraphicsBeginImageContext(sourceImage.size)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: sourceImageWidth, height: sourceImageHeight))
        addImage.draw(in: CGRect(x: (sourceImageWidth - 108)/2, y: sourceImageHeight * 30 / 37, width: 108, height: 108), blendMode: CGBlendMode.sourceIn, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}

// MARK: - Methods
public extension UIImage {
    
    /// 保存图片到本地相册
    public func saveToLocal(completion: ((Bool, Error?) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: self)
                    }, completionHandler: completion)
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: self)
                    }, completionHandler: completion)
                }
            }
        case .authorized:
            PHPhotoLibrary.shared().performChanges({
                _ = PHAssetChangeRequest.creationRequestForAsset(from: self)
            }, completionHandler: completion)
        case .denied:
            HudManager.shared.dismissHud()
            ZFAlertView(title: "尚未开启相册权限", leftTitle: "取消", rightTitle: "去开启") { (isLeft) in
                guard !isLeft else { return }
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.openURL(url)
            }.show()
        default:
            completion?(false, nil)
        }
    }
}
