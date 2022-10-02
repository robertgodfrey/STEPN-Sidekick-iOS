//
//  STEPN_SidekickApp.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/6/22.
//

import SwiftUI

@main
struct STEPN_SidekickApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainViewStarter()
        }
    }
}
