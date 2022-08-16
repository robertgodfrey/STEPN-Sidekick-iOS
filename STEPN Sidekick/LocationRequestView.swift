//
//  LocationRequestView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/15/22.
//

import SwiftUI

struct LocationRequestView: View {
    @State var returnToSettings: Bool = false

    var body: some View {
        ZStack {
            if (returnToSettings) {
                ActivitySettings()
            } else {
                Color(.systemBlue).ignoresSafeArea()
                
                VStack {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("This app requires precise background location permissions to track speed while running in the background.")
                        .multilineTextAlignment(.center)
                        .padding(30)
                    
                    Text("Turn on now?")
                        .padding(.vertical, 20)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            print("no location permissions")
                            returnToSettings = true
                        }) {
                            Text ("Cancel")
                                .font(Font.custom("Roboto-Medium", size: 18))
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 60, maxWidth: 80, minHeight: 40)
                        .padding(.horizontal, 20)
                        .background(Color.red)
                        .clipShape(Capsule())
                        
                        Button(action: {
                            LocationManager.shared.requestLocation()
                            print("requestin")
                        }) {
                            Text ("Okay")
                                .font(Font.custom("Roboto-Medium", size: 18))
                                .foregroundColor(Color(.systemBlue))
                        }
                        .frame(minWidth: 60, maxWidth: 80, minHeight: 40)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    
                }.foregroundColor(.white)
            }

        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
