//
//  CustomTabBar.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/28/22
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: String
    var bottomEdge: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            // tab buttons
            ForEach(["Activity", "Optimizer", "Info"],id: \.self) { image in
                TabButton(image: image, currentTab: $currentTab)
            }
        }   .padding(.top, 20)
            .padding(.bottom, bottomEdge)
            .background(Color("Nav Bar Grey"))
            .cornerRadius(30, corners: [.topLeft, .topRight])
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainViewStarter()
    }
}

struct TabButton: View {
    var image: String
    @Binding var currentTab: String
    
    var body: some View {
        Button {
            withAnimation{
                currentTab = image
            }
        } label : {
            
            Image(image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(Color("Almost Black"))
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .frame(width: 60, height: 24)
                        .foregroundColor(Color("Button Green"))
                        .opacity(currentTab == image ? 1 : 0)
                )
        }
    }
}
