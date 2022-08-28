//
//  LocationRequestView.swift
//  STEPN Sidekick
//
//  View to let user know why location permissions are needed and how they will be used.
//
//  Created by Rob Godfrey
//  Last updated 22 Aug 22
//

import SwiftUI

struct LocationRequestView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    // check if we've already requested location perms before
    @AppStorage("requestedLocationPerms") private var requestedPerms: Bool = false

    @State var returnToSettings: Bool = false
    
    var body: some View {
        ZStack {
            if returnToSettings {
                ActivitySettings()
            } else {
                Color(.systemBlue).ignoresSafeArea()
                
                VStack {
                    Spacer()

                    Image("person_joggin")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                    
                    Text("This app requires precise location permissions to accurately track speed.")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Roboto-Regular", size: 17))
                        .padding(.horizontal, 30)
                    
                    Text(requestedPerms ? "Please turn on precise background location permissions in Settings (required for speed updates while app is running in the background)." :
                            "Please allow background permissions so that speed can be updated while the app is running in the background.")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Roboto-Regular", size: 17))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                    
                    Text("Turn on now?")
                        .font(Font.custom("Roboto-Medium", size: 17))
                        .padding(.bottom, 30)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            print("no location permissions")
                            returnToSettings = true
                            requestedPerms = true
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
                            Text ("Okay")
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

        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
