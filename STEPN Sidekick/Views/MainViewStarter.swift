//
//  TempView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/27/22.
//

import SwiftUI

struct MainViewStarter: View {
    var body: some View {
        // for bottom safe area
        GeometryReader { proxy in
            let bottomEdge = proxy.safeAreaInsets.bottom
            
            MainView(bottomEdge: (bottomEdge == 0 ? 15 : bottomEdge - 10))
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

struct MainViewStarter_Previews: PreviewProvider {
    static var previews: some View {
        MainViewStarter()
    }
}
