//
//  AppDelegate.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 10/1/22.
//

import Foundation
import AppLovinSDK

class AppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Please make sure to set the mediation provider value to "max" to ensure proper functionality
        ALSdk.shared()!.mediationProvider = "max"
        
        ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
            // Start loading ads
        }
        return true
    }
}
