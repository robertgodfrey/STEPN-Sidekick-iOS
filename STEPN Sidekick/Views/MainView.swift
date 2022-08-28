//
//  MainView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey
//  Last updated 27 Aug 22
//
//  TODO: add lock screen widget for iOS 16
//    - ads, eventually
//    - nav bar (obvi)
//    - remove all print statements
//    - might need to change bottom edge in each view, check later (12:50 of video)

import SwiftUI

struct MainView: View {
    @State var currentTab = "Activity"
    @State var hideTab = false
    var bottomEdge: CGFloat
    
    // to hide tab view
    init(bottomEdge: CGFloat) {
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            ActivitySettings(hideTab: $hideTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
                .tag("Activity")
            Text("Info")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
                .tag("Info")
        }
        .overlay(
            VStack {
                CustomTabBar(currentTab: $currentTab, bottomEdge: bottomEdge)
            }
                .offset(y: hideTab ? (50 + (bottomEdge == 0 ? 15 : bottomEdge + 10)) : 0)
            , alignment: .bottom
            
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainViewStarter()
    }
}
