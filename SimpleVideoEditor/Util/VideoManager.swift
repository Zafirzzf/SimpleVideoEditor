//
//  VideoManager.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/29.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import AVFoundation

class VideoManager {
    static func outputVideo(of videoItem: VideoPickItem, complete: @escaping BoolCallback) {
        let asset = videoItem.asset
        guard let assetReader = try? AVAssetReader(asset: asset) else { return }
        
        let videoTrack: AVAssetTrack = asset.tracks(withMediaType: .video)[0]
        let audioTrack: AVAssetTrack = asset.tracks(withMediaType: .audio)[0]
        
        let readerVideoTrackOutput = AVAssetReaderTrackOutput(
            track: videoTrack,
            outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                             kCVPixelBufferIOSurfacePropertiesKey as String: NSDictionary()]
        )
        let readerAudioTrackOutput = AVAssetReaderTrackOutput(
            track: audioTrack,
            outputSettings: [AVFormatIDKey: kAudioFormatLinearPCM])
        
        if assetReader.canAdd(readerVideoTrackOutput) {
            assetReader.add(readerVideoTrackOutput)
        }
        if assetReader.canAdd(readerAudioTrackOutput) {
            assetReader.add(readerAudioTrackOutput)
        }
        
        assetReader.startReading()
        let outputURL = URL(fileURLWithPath: tempVideoPath)
        guard let assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mp4) else {
            print(" error: ", #line)
            return
        }
        
        let videoCompressionProperty: [String: Any] = [
            AVVideoAverageBitRateKey: 1.5 * videoItem.size.width * videoItem.size.height,
            AVVideoExpectedSourceFrameRateKey: 15,
            AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel]
        
        let videoSetting: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoItem.size.width,
            AVVideoHeightKey: videoItem.size.height,
            AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
            AVVideoCompressionPropertiesKey: videoCompressionProperty]
        
        let assetVideoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSetting, sourceFormatHint: nil)
        assetVideoWriterInput.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        
        var audioChannal = AudioChannelLayout(mChannelLayoutTag: kAudioChannelLayoutTag_Stereo,
                                              mChannelBitmap: [],
                                              mNumberChannelDescriptions: 0,
                                              mChannelDescriptions: .init())
        let channalData = NSData(bytes: &audioChannal, length: 12)
        let audioSetting: [String: Any] = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                           AVEncoderBitRateKey: 64000,
                                           AVSampleRateKey: 44100,
                                           AVChannelLayoutKey: channalData,
                                           AVNumberOfChannelsKey: 2]
        let assetAudioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSetting)
        
        if assetWriter.canAdd(assetVideoWriterInput) {
            assetWriter.add(assetVideoWriterInput)
        }
        if assetWriter.canAdd(assetAudioWriterInput) {
            assetWriter.add(assetAudioWriterInput)
        }
        
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)
        
        let group = DispatchGroup()
        let videoWriterQueue = DispatchQueue(label: "videoWriter")
        let audioWriterQueue = DispatchQueue(label: "audioWriter")
        var isVideoComplete = false
        var isAudioComplete = false
        
        group.enter()
        assetVideoWriterInput.requestMediaDataWhenReady(on: videoWriterQueue) {
            while !isVideoComplete && assetVideoWriterInput.isReadyForMoreMediaData {
                autoreleasepool {
                    if let buffer = readerVideoTrackOutput.copyNextSampleBuffer() {
                        assetVideoWriterInput.append(buffer)
                    } else {
                        isVideoComplete = true
                    }
                }
            }
            if isVideoComplete {
                assetVideoWriterInput.markAsFinished()
                group.leave()
            }
        }
        
        group.enter()
        assetAudioWriterInput.requestMediaDataWhenReady(on: audioWriterQueue) {
            
            while !isAudioComplete && assetAudioWriterInput.isReadyForMoreMediaData {
                autoreleasepool {
                    if let buffer = readerAudioTrackOutput.copyNextSampleBuffer() {
                        assetAudioWriterInput.append(buffer)
                    } else {
                        isAudioComplete = true
                    }
                }
            }
            if isAudioComplete {
                assetAudioWriterInput.markAsFinished()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            assetWriter.finishWriting {
                let status = assetWriter.status
                if status == .completed {
                    print("finishWriting: finish \n\n\n")
                    assetReader.cancelReading()
                    assetWriter.cancelWriting()
                    PhotoLibraryManager.saveVideoToAblum(with: outputURL) { (success) in
                        complete(true)
                    }
                } else {
                    complete(false)
                    print("finishWriting: error: \n\n", assetWriter.error)
                }
            }
        }
    }
    
    static var tempVideoPath: String {
        NSTemporaryDirectory() + Int(Date().timeIntervalSince1970).description + ".mp4"
    }
}
