//
//  LocationRequestView.swift
//  STEPN Sidekick
//
//  View to let user know why location permissions are needed and how they will be used.
//
//  Created by Rob Godfrey
//  Last updated 3 Sep 22
//

import SwiftUI

struct LocationRequestView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    // check if we've already requested location perms before
    @AppStorage("requestedLocationPerms") private var requestedPerms: Bool = false

    @State var returnToSettings: Bool = false
    @Binding var hideTab: Bool
    
    var body: some View {
        ZStack {
            if returnToSettings {
                ActivitySettings(hideTab: $hideTab)
            } else {
                Color(.systemBlue).ignoresSafeArea()
                
                VStack {
                    Spacer()

                    Image("person_joggin")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                                    
                    Text(requestedPerms ? "Precise location permissions are required to accurately track speed. Please turn on location permissions in your phone's settings.\n(Settings -> Privacy -> Location Services -> STEPN Sidekick" :
                            "This app requires precise location permissions to accurately track speed.")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Roboto-Regular", size: 17))
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    Text("Turn on now?")
                        .font(Font.custom("Roboto-Medium", size: 17))
                        .padding(.bottom, 30)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            print("no location permissions")
                            returnToSettings = true
                        }) {
                            Text ("Cancel")
                                .font(Font.custom("Roboto-Medium", size: 19))
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 60, maxWidth: 80, minHeight: 42)
                        .padding(.horizontal, 20)
                        .background(Color.red)
                        .clipShape(Capsule())
                        
                        Button(action: {
                            if !requestedPerms {
                                LocationManager.shared.requestLocation()
                                print("requestin")
                                self.mode.wrappedValue.dismiss()
                                returnToSettings = true
                                requestedPerms = true
                            } else {
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                                }
                                returnToSettings = true
                                requestedPerms = true
                            }
                        }) {
                            Text (requestedPerms ? "Settings" : "Okay")
                                .font(Font.custom("Roboto-Medium", size: 19))
                                .foregroundColor(Color(.systemBlue))
                        }
                        .frame(minWidth: 60, maxWidth: 80, minHeight: 42)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    Spacer()
                    
                }.foregroundColor(.white)
                    .preferredColorScheme(.dark)

            }

        }.onAppear() {
            hideTab = true
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView(hideTab: .constant(true))
    }
}
