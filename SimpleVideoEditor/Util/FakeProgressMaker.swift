//
//  FakeProgressMaker.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/2/1.
//  Copyright © 2020 周正飞. All rights reserved.
//

import Foundation

class FakeProgressMaker {
    
    var progress: Float = 0 {
        didSet {
            if progress > 1.0 { progress = 1.0 }
            progressCallback(progress)
        }
    }
    let progressCallback: (Float) -> Void
    
    init(target: AnyObject, progressCallback: @escaping (Float) -> Void) {
        self.progressCallback = progressCallback
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak target, weak self] (timer) in
            guard target != nil, let self = self, self.progress <= 1.0 else {
                timer.invalidate()
                return
            }
            if self.progress >= 0.99 {
                return
            } else if self.progress >= 0.5 {
                self.progress += 0.0005
            } else {
                self.progress += 0.0007
            }
        }
    }
    
    func finish() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            guard self.progress <= 1.0 else {
                timer.invalidate()
                return
            }
            self.progress += 0.01
        }
    }
}
