//
//  SwiftUIView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 10/1/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                                
                ScrollView {
                    ZStack {
                        Color("Light Green")
                        
                        
                    }
                }
            }
        }  .ignoresSafeArea()
            .preferredColorScheme(.light)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
