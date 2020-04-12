//
//  AppDelegate.swift
//  SimpleVideoEditor
//
//  Created by 周正飞 on 2020/1/23.
//  Copyright © 2020 周正飞. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = PreSelectViewController()
        window?.makeKeyAndVisible()
        Bugly.start(withAppId: "749b56a434")
        FirebaseApp.configure()
        if PreferenceConfig.openAppTimes > 1 {
            _ = GDTAdManager.shared
        } else {
            PreferenceConfig.openAppTimes = PreferenceConfig.openAppTimes + 1
        }
        
//        let path = Bundle.main.path(forResource: "test1", ofType: "mp4")!
//        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
//            UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
//        }
        return true
    }

}

