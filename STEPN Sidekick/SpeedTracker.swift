//
//  SpeedTracker.swift
//  STEPN Sidekick
//
//  Displays current/average speed, time/energy remaining, GPS signal strength
//
//  Created by Rob Godfrey
//  Last updated 16 Aug 22
//

import SwiftUI
import AVFoundation

struct SpeedTracker: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    let shoeType: String
    let minSpeed: Double
    let maxSpeed: Double
    @State var energy: Double
    let tenSecondTimer: Bool
    let voiceAlertsCurrentSpeed: Bool
    let voiceAlertsAvgSpeed: Bool
    let voiceAlertsTime: Bool
    let voiceAlertsMinuteThirty: Bool
    
    @State private var returnToSettings: Bool = false
    @State private var currentSpeed: Double = 0
    @State private var gpsAccuracy: Double = 0
    @State private var gpsBars: Int = 0
    
    // average speed stuff
    @State private var currentAvgSpeed: Double = 0
    @State private var avgSpeeds = [Float](repeating: 0, count: 300)
    @State private var avgSpeedCounter: Int = 0
    @State private var speedSum: Double = 0
    @State private var firstFive: Bool = true
    @State private var justPlayed: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() 
    @State private var timeRemaining: Int = 0
    @State private var originalTime: Int = 0
    @State var isActive: Bool = true
        
    var body: some View {
        
        if locationManager.userLocation == nil {
            LocationManager.shared.requestLocation()
        }
        let currentLocation = locationManager.userLocation
    
        // to find safe area
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
                
        return Group {
            if (returnToSettings) {
                ActivitySettings()
            } else {
                ZStack(alignment: .top) {
                    Color("Speed Tracker Background")
                    
                    VStack(spacing: 40) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Speed Tracker Foreground"))
                                .frame(minWidth: 380, maxWidth: 420, minHeight: 10, maxHeight: topPadding + 70)
                                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])

                            
                            HStack {
                                HStack(spacing: 4) {
                                    Image("energy_bolt")
                                        .renderingMode(.template)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color("Energy Blue"))
                                        .frame(height: 18)
                                    Text(String(energy))
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
                                                .foregroundColor(Color(getGpsAccuracyColor()))
                                                .frame(width: 5, height: 10)
                                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                .foregroundColor(gpsBars > 1 ? Color(getGpsAccuracyColor()) : Color("Gandalf"))
                                                .frame(width: 5, height: 15)
                                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                .foregroundColor(gpsBars > 2 ? Color(getGpsAccuracyColor()) : Color("Gandalf"))
                                                .frame(width: 5, height: 20)
                                        }
                                    }
                                }
                                .padding(.trailing, 15)
                            }
                            .padding(.top, topPadding - 16)
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 2) {
                                HStack(spacing: 6) {
                                    // TODO add mo feet
                                    Image("footprint")
                                        .renderingMode(.template)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(height: 17)
                                    Text(shoeType)
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(.white)
                                        .padding(.top, 2)
                                }
                                
                                Text("\(String(minSpeed)) - \(String(maxSpeed)) km/h")
                                    .font(Font.custom(fontHeaders, size: 18))
                                    .foregroundColor(.white)
                            }.padding(.top, topPadding - 12)
                        }
                        
                        HStack(spacing: 0) {
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("Current Speed:")
                                    .font(Font.custom(fontHeaders, size: 16))
                                    .foregroundColor(Color.white)
                                
                                Text(currentSpeed < 1 ? "0.0" : String(currentSpeed))
                                    .font(Font.custom("Roboto-BlackItalic", size: 80))
                                    .foregroundColor(Color.white)
                                Text("km/h")
                                    .font(Font.custom("Roboto-BlackItalic", size: 40))
                                    .foregroundColor(Color.white)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("5-Min Average:")
                                    .font(Font.custom(fontHeaders, size: 16))
                                    .foregroundColor(Color.white)
                                
                                Text(String(currentAvgSpeed))
                                    .font(Font.custom("Roboto-BlackItalic", size: 80))
                                    .foregroundColor(Color.white)
                                Text("km/h")
                                    .font(Font.custom("Roboto-BlackItalic", size: 40))
                                    .foregroundColor(Color.white)
                            }
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 0) {
                            Text("Time Remaining:")
                                .font(Font.custom(fontHeaders, size: 16))
                                .foregroundColor(Color("Energy Blue"))
                            Text(timeFormatted())
                                .font(Font.custom("RobotoCondensed-Bold", size: 86))
                                .foregroundColor(Color("Energy Blue"))
                        }
                        
                        ZStack {
                            
                            HStack(spacing: 30) {
                                Button(action: {
                                    returnToSettings = true
                                }) {
                                    Image("button_stop")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(12)
                                        .frame(width: 110, height: 110)
                                        .opacity(isActive ? 0 : 1)
                                }.disabled(isActive ? true : false)

                                
                                Button(action: {
                                    isActive.toggle()
                                    locationManager.resumeLocationUpdates()
                                }) {
                                    Image("button_play")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(12)
                                        .frame(width: 110, height: 110)
                                        .opacity(isActive ? 0 : 1)
                                }.disabled(isActive ? true : false)
                            }
                                                                
                            HStack(spacing: 20){
                                Button(action: {
                                    timeRemaining -= 5
                                }) {
                                    Text("-5")
                                        .font(Font.custom("Roboto-Black", size: 35))
                                        .foregroundColor(Color.white)
                                        .opacity(isActive ? 1 : 0)
                                        .padding()
                                }.disabled(isActive ? false : true)
                                
                                
                                Button(action: {
                                    isActive.toggle()
                                    locationManager.stopLocationUpdates()
                                }) {
                                    Image("button_pause")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(12)
                                        .frame(width: 110, height: 110)
                                        .opacity(isActive ? 1 : 0)
                                }.disabled(isActive ? false : true)
                                
                                Button(action: {
                                    timeRemaining += 5
                                }) {
                                    Text("+5")
                                        .font(Font.custom("Roboto-Black", size: 35))
                                        .foregroundColor(Color.white)
                                        .opacity(isActive ? 1 : 0)
                                        .padding()
                                }.disabled(isActive ? false : true)
                            }
                        }
                    }
                }.ignoresSafeArea()
                    .onReceive(timer, perform: { _ in
                        guard isActive else { return }
                        
                        if timeRemaining > 0 {
                            
                            // MARK: Update current and average speeds
                            currentSpeed = Double(round((currentLocation?.speed ?? 0.0) * 36) / 10)
                            
                            if avgSpeedCounter < 60 * 5 {
                                if firstFive {
                                    avgSpeeds[avgSpeedCounter] = Float(currentSpeed)
                                    speedSum += Double(avgSpeeds[avgSpeedCounter])
                                    avgSpeedCounter += 1
                                    currentAvgSpeed = Double(round(speedSum / Double(avgSpeedCounter) * 10) / 10)
                                } else {
                                    speedSum -= Double(avgSpeeds[avgSpeedCounter])
                                    avgSpeeds[avgSpeedCounter] = Float(currentSpeed)
                                    speedSum += Double(avgSpeeds[avgSpeedCounter])
                                    currentAvgSpeed = Double(round(speedSum / 30) / 10)
                                    avgSpeedCounter += 1
                                }
                            } else {
                                speedSum -= Double(avgSpeeds[0])
                                avgSpeeds[0] = Float(currentSpeed)
                                speedSum += Double(avgSpeeds[0])
                                currentAvgSpeed = Double(round(speedSum / 30) / 10)
                                avgSpeedCounter = 1
                                firstFive = false
                            }
                            
                            if currentAvgSpeed < 0 {
                                currentAvgSpeed = 0.0
                            }
                            
                            // MARK: Speed alarm
                            if currentSpeed < minSpeed || currentSpeed > maxSpeed {
                                if !justPlayed {
                                    if currentSpeed < minSpeed {
                                        // low-pitched alert
                                        
                                        // TODO: add new sound file to project
                                        
                                        // GSAudio.sharedInstance.playSound(sound: .alert_sound)
                                    } else {
                                        // high-pitched alert
                                        // GSAudio.sharedInstance.playSound(sound: .alert_sound)
                                    }
                                    justPlayed = true
                                    print("playin!")
                                } else {
                                    justPlayed = false
                                }
                            }
                            
                            // MARK: Modify energy count
                            if timeRemaining % 60 == 0 {
                                energy = round(Double(timeRemaining) / 60 / 5 * 10) / 10
                            }
                            
                            // MARK: GPS Accuracy
                            gpsAccuracy = currentLocation?.horizontalAccuracy ?? 0.0
                            
                            if gpsAccuracy == 0 {
                                gpsBars = 0
                            } else if gpsAccuracy < 15 {
                                gpsBars = 3
                            } else if gpsAccuracy < 25 {
                                gpsBars = 2
                            } else {
                                gpsBars = 1
                            }
                            
                            // MARK: Voice updates
                            if timeRemaining % 300 == 0 &&
                                (voiceAlertsTime || voiceAlertsCurrentSpeed || voiceAlertsAvgSpeed) {
                                
                                if voiceAlertsTime {
                                    Task {
                                        await playVoiceTime()
                                    }
                                } else if voiceAlertsCurrentSpeed {
                                    playVoiceCurrentSpeed()
                                } else {
                                    playVoiceAvgSpeed()
                                }
                            }
                            
                            // MARK: 1 min / 30 sec voice alert
                            if (timeRemaining == 60 || timeRemaining == 30) && voiceAlertsMinuteThirty {
                                if timeRemaining == 60 {
                                    GSAudio.sharedInstance.playSound(sound: .one_minute_remaining)
                                }
                                
                                if timeRemaining == 30 {
                                    GSAudio.sharedInstance.playSound(sound: .thirty_seconds_remaining)
                                }
                            }
                            
                            if timeRemaining == 3 {
                                threeSecondCountdown()
                            }

                            timeRemaining -= 1
                        } else {
                            isActive = false
                            timeRemaining = 0
                        }
                    })
            }
        }.onAppear() {
            timeRemaining = Int(energy * 5 * 60) + 30
        }
    }
    
    func playVoiceTime() async {
        var minConversion: Int = timeRemaining / 60 + 1
        var hourMillis: Double = 0
        
        // skips if time (somehow) greater than 3 hrs
        if minConversion < 180 {
            GSAudio.sharedInstance.playSound(sound: .time_remaining)
            
            do {
                try await Task.sleep(nanoseconds: UInt64(1150 * Double(NSEC_PER_MSEC)))
                // two hour range
                if minConversion >= 120 {
                    if minConversion > 120 {
                        GSAudio.sharedInstance.playSound(sound: .two_hours)
                        hourMillis = 517
                    } else {
                        GSAudio.sharedInstance.playSound(sound: .two_hours_end)
                        hourMillis = 800
                    }
                    
                    minConversion -= 120
                    
                    try await Task.sleep(nanoseconds: UInt64(hourMillis * Double(NSEC_PER_MSEC)))
                }
                
                // one hour range
                if minConversion >= 60 {
                    if minConversion > 60 {
                        GSAudio.sharedInstance.playSound(sound: .one_hour)
                    } else {
                        GSAudio.sharedInstance.playSound(sound: .one_hour_end)
                    }
                    
                    minConversion -= 60
                    
                    try await Task.sleep(nanoseconds: UInt64(500 * Double(NSEC_PER_MSEC)))
                }
                                
                print("mins remaining: \(minConversion)")
                switch minConversion {
                case 5:
                    GSAudio.sharedInstance.playSound(sound: .five)
                    try await Task.sleep(nanoseconds: UInt64(390 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 10:
                    GSAudio.sharedInstance.playSound(sound: .ten)
                    try await Task.sleep(nanoseconds: UInt64(290 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 15:
                    GSAudio.sharedInstance.playSound(sound: .fifteen)
                    try await Task.sleep(nanoseconds: UInt64(490 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 20:
                    GSAudio.sharedInstance.playSound(sound: .twenty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 25:
                    GSAudio.sharedInstance.playSound(sound: .twenty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .five_mid)
                    try await Task.sleep(nanoseconds: UInt64(290 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 30:
                    GSAudio.sharedInstance.playSound(sound: .thirty)
                    try await Task.sleep(nanoseconds: UInt64(340 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 35:
                    GSAudio.sharedInstance.playSound(sound: .thirty)
                    try await Task.sleep(nanoseconds: UInt64(340 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .five_mid)
                    try await Task.sleep(nanoseconds: UInt64(290 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 40:
                    GSAudio.sharedInstance.playSound(sound: .forty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 45:
                    GSAudio.sharedInstance.playSound(sound: .forty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .five_mid)
                    try await Task.sleep(nanoseconds: UInt64(290 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 50:
                    GSAudio.sharedInstance.playSound(sound: .fifty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                case 55:
                    GSAudio.sharedInstance.playSound(sound: .fifty)
                    try await Task.sleep(nanoseconds: UInt64(325 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .five_mid)
                    try await Task.sleep(nanoseconds: UInt64(290 * Double(NSEC_PER_MSEC)))
                    GSAudio.sharedInstance.playSound(sound: .minutes)
                    
                default:
                    break
                }
                
                try await Task.sleep(nanoseconds: UInt64(1000 * Double(NSEC_PER_MSEC)))


                if voiceAlertsCurrentSpeed {
                    playVoiceCurrentSpeed()
                } else if voiceAlertsAvgSpeed {
                    playVoiceAvgSpeed()
                }

            } catch {
                print("i can't sleep :)")
            }
        }        
    }
    
    func playVoiceCurrentSpeed() {
        
    }
    
    func playVoiceAvgSpeed() {
        
    }
    
    func threeSecondCountdown() {
        
    }
    
    func getGpsAccuracyColor() -> String {
        var color: String = ""
        
        switch gpsBars {
        case 1:
            color = "Gps Red"
        case 2:
            color = "Gps Yellow"
        case 3:
            color = "Gps Green"
        default:
            color = "Gandalf"
        }
        
        return color
    }
        
    func timeFormatted() -> String {
        var timeString: String = ""
        
        if timeRemaining >= 3600 {
            timeString += String(Int(timeRemaining / 3600)) + ":"
        }
        
        let minutes = Int(timeRemaining) / 60 % 60
        let seconds = Int(timeRemaining) % 60
        
        timeString += String(format:"%02i:%02i", minutes, seconds)
        
        return timeString
    }
}

struct SpeedTracker_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTracker(
            shoeType: "Runner",
            minSpeed: -2.0,
            maxSpeed: 20.0,
            energy: 2,
            tenSecondTimer: true,
            voiceAlertsCurrentSpeed: true,
            voiceAlertsAvgSpeed: true,
            voiceAlertsTime: true,
            voiceAlertsMinuteThirty: true)
    }
}
