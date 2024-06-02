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
        let initConfig = ALSdkInitializationConfiguration(sdkKey: ProcessInfo.processInfo.environment["APP_LOVIN_SDK_KEY"] ?? "") { builder in
            builder.mediationProvider = ALMediationProviderMAX
          }
        // Initialize the SDK with the configuration
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
          // Start loading ads
        }
        return true
    }
}
