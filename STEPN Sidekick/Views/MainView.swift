//
//  MainView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey
//
//  Last updated 26 Nov 22
//

import SwiftUI
import StoreKit

struct MainView: View {
    @State var currentTab = "Activity"
    @State var hideTab = false
    @State var showAds = true
    @StateObject var shoes = OptimizerShoes()
    @StateObject var storeManager = StoreManager()
    var bottomEdge: CGFloat
    
    // to hide tab view
    init(bottomEdge: CGFloat) {
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
    }
    
    var body: some View {
        VStack (spacing: 0) {
            TabView(selection: $currentTab) {
                ActivitySettings(hideTab: $hideTab, showAds: $showAds)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .tag("Activity")
                Optimizer(hideTab: $hideTab, showAds: $showAds)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .tag("Optimizer")
                About(hideTab: $hideTab, showAds: $showAds)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Light Green"))
                    .tag("Info")
                    .onAppear(perform: {
                        SKPaymentQueue.default().add(storeManager)
                    })
            }.environmentObject(shoes)
                .environmentObject(storeManager)
            .overlay(
                VStack {
                    CustomTabBar(currentTab: $currentTab, bottomEdge: bottomEdge)
                }
                    .offset(y: hideTab ? (50 + (bottomEdge == 0 ? 15 : bottomEdge + 10)) : 0)
                , alignment: .bottom
                
            )
        }.ignoresSafeArea()
            .onAppear(perform: {
                storeManager.getProducts(productIDs: ["remove_ads"])
                showAds = UserDefaults.standard.bool(forKey: "remove_ads")
            })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainViewStarter()
    }
}
