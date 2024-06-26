//
//  AppDelegate.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 10/1/22.
//

import Foundation
import AppLovinSDK
import AppTrackingTransparency

class AppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let infoDict: [String: Any] = Bundle.main.infoDictionary else { return false }
        guard let appLovinSdkKey: String = infoDict["AppLovinKey"] as? String else { return false }
        let initConfig = ALSdkInitializationConfiguration(sdkKey: appLovinSdkKey) { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }
        let settings = ALSdk.shared().settings
        settings.termsAndPrivacyPolicyFlowSettings.isEnabled = true
        settings.termsAndPrivacyPolicyFlowSettings.privacyPolicyURL = URL(string: "https://stepnsidekick.com/privacy-policy.txt")

        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                    case .authorized:
                        print("enable tracking")
                    case .denied:
                        print("disable tracking")
                    default:
                        print("disable tracking")
                }
            }
        }
        // Initialize the SDK with the configuration
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
          // Start loading ads
        }
        return true
    }
}
