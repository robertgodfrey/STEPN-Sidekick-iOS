//
//  MainView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey
//
//  Last updated 3 Feb 24
//

import SwiftUI
import StoreKit

struct MainView: View {
    @State var currentTab = "Activity"
    @State var hideTab = false
    @State var showAds = true
    @State var gmtMagicNumbers: GmtMagicNumbers = GmtMagicNumbers(a: 0.0, b: 0.0, c: 0.0)
    
    @StateObject var shoes = OptimizerShoes()
    @StateObject var imageUrls = ShoeImages()
    @StateObject var storeManager = StoreManager()
    
    @AppStorage("gmtNumA") private var gmtNumA: Double = 0.0696
    @AppStorage("gmtNumB") private var gmtNumB: Double = 0.4821
    @AppStorage("gmtNumC") private var gmtNumC: Double = 0.25
    
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
                .environmentObject(imageUrls)
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
                showAds = !UserDefaults.standard.bool(forKey: "remove_ads")
                gmtNumsApiCall()
            })
    }
    
    func gmtNumsApiCall() {
        guard let url = URL(string: "https://stepn-sidekick.vercel.app/gmt") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        if let apiKey = Bundle.main.infoDictionary?["SidekickAPI"] as? String {
            request.setValue(apiKey, forHTTPHeaderField: "API-Key")
        } else {
            print("API key not found")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(GmtMagicNumbers.self, from: data) {
                    DispatchQueue.main.async {
                        gmtMagicNumbers = response
                        gmtNumA = gmtMagicNumbers.a
                        gmtNumB = gmtMagicNumbers.b
                        gmtNumC = gmtMagicNumbers.c
                    }
                    return
                }
            }
        }.resume()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainViewStarter()
    }
}
