//
//  STEPN_SidekickApp.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/6/22.
//

import SwiftUI

@main
struct STEPN_SidekickApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ActivitySettings()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
