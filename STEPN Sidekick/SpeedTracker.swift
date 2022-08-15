//
//  SpeedTracker.swift
//  STEPN Sidekick
//
//  Displays current/average speed, time/energy remaining, GPS signal strength
//
//  Created by Rob Godfrey
//  Last updated 14 Aug 22
//

import SwiftUI

struct SpeedTracker: View {
    
    @State private var isActive: Bool = true
    @State var timeRemaining: CGFloat
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // .main is running on main thread, need to change this
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Speed Tracker Background")
            
            VStack(spacing: 40) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color("Speed Tracker Foreground"))
                        .frame(minWidth: 380, maxWidth: 420, minHeight: 100, maxHeight: 120)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image("energy_bolt")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("Energy Blue"))
                                .frame(height: 25)
                            Text("0.0")
                                .font(Font.custom(fontTitles, size: 18))
                                .foregroundColor(Color("Energy Blue"))
                        }.padding(.leading, 25)
                        
                        VStack { }.frame(maxWidth: .infinity)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(Color("Speed Tracker Background"))
                                .frame(width: 85, height: 38)
                            
                            HStack(spacing: 7) {
                                Text("GPS")
                                    .font(Font.custom(fontTitles, size: 18))
                                    .foregroundColor(.white)
                                
                                HStack(alignment: .bottom, spacing: 2) {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 5, height: 10)
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 5, height: 15)
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 5, height: 20)
                                }
                            }
                        }.padding(.trailing, 15)
                    }
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 2) {
                        HStack(spacing: 6) {
                            Image("footprint")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(height: 17)
                            Text("Walker")
                                .font(Font.custom(fontTitles, size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 2)
                        }
                        
                        Text("1.0 - 6.0 km/h")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(.white)
                    }.padding(.top, 30)
                }
                
                HStack(spacing: 50) {
                    VStack(spacing: 0) {
                        Text("Current Speed")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color.white)
                        
                        Text("0.0")
                            .font(Font.custom("Roboto-BlackItalic", size: 90))
                            .foregroundColor(Color.white)
                        Text("km/h")
                            .font(Font.custom("Roboto-BlackItalic", size: 46))
                            .foregroundColor(Color.white)

                    }
                    
                    VStack(spacing: 0) {
                        Text("5-Min Average")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color.white)
                        
                        Text("0.0")
                            .font(Font.custom("Roboto-BlackItalic", size: 90))
                            .foregroundColor(Color.white)
                        Text("km/h")
                            .font(Font.custom("Roboto-BlackItalic", size: 46))
                            .foregroundColor(Color.white)

                    }
                    
                }
                
                VStack(spacing: 0) {
                    Text("Time Remaining:")
                        .font(Font.custom(fontHeaders, size: 16))
                        .foregroundColor(Color("Energy Blue"))
                    Text(String(Int(timeRemaining)))
                        .font(Font.custom("RobotoCondensed-Bold", size: 92))
                        .foregroundColor(Color("Energy Blue"))

                }
                                
                HStack(spacing: 45){
                    Button(action: {
                        timeRemaining -= 5
                    }) {
                        Text("-5")
                            .font(Font.custom("Roboto-Black", size: 35))
                            .foregroundColor(Color.white)
                    }
                    
                    Button(action: {
                        isActive.toggle()
                    }) {
                        Image("button_pause")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(12)
                            .frame(width: 110, height: 110)
                    }
                    
                    Button(action: {
                        timeRemaining += 5
                    }) {
                        Text("+5")
                            .font(Font.custom("Roboto-Black", size: 35))
                            .foregroundColor(Color.white)
                    }
                    
                }.padding(.vertical, 60)
            }
        }.ignoresSafeArea()
            .onReceive(timer, perform: { _ in
                guard isActive else { return }
                
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    isActive = false
                    timeRemaining = 0
                }
            })
    }
}

struct SpeedTracker_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTracker(timeRemaining: 10.0)
    }
}
