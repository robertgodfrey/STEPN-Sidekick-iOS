//
//  SpeedTracker.swift
//  STEPN Sidekick
//
//  Gets user's speed every second and plays alarm sound if speed is outside specified range.
//  Displays current/average speed, time/energy remaining, and GPS signal strength
//
//  Created by Rob Godfrey
//  Last updated 3 Sep 22
//

import SwiftUI
import AVFoundation


struct SpeedTracker: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    @Binding var hideTab: Bool
    
    @StateObject private var timerVm = ViewModel()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let shoeType: String
    let minSpeed: Double
    let maxSpeed: Double
    @State var energy: Double
    @State var tenSecondTimer: Bool
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
    
    @State private var timeRemaining: Int = 0
    @State private var endDate: Date? = nil
    @State private var isActive: Bool = true
    @State private var smol: Bool = false
            
    var body: some View {
        
        if returnToSettings {
            ActivitySettings(hideTab: $hideTab)
        } else {
            ZStack(alignment: .top) {
                
                Color("Speed Tracker Background")
                
                VStack(spacing: 40) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("Speed Tracker Foreground"))
                            .frame(minWidth: 380, maxWidth: 420, minHeight: 10, maxHeight: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 70)
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
                        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) - 16)
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            HStack(spacing: 0) {
                                Image("footprint")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: shoeType == "Runner" ? 10 : 0, height: 17)
                                
                                Image("footprint")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: shoeType == "Runner" || shoeType == "Jogger" ? 10 : 0, height: 17)
                                
                                Image(getShoeResource())
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 10, maxWidth: (shoeType == "Trainer" ? 16 : 10), minHeight: 10, maxHeight: 17)
                                    .padding(.trailing, 4)
                                
                                Text(shoeType)
                                    .font(Font.custom(fontTitles, size: 18))
                                    .foregroundColor(.white)
                                    .padding(.top, 2)
                            }
                            
                            Text("\(String(minSpeed)) - \(String(maxSpeed)) km/h")
                                .font(Font.custom(fontHeaders, size: 18))
                                .foregroundColor(.white)
                        }.padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) - 12)
                    }
                    
                    ZStack(alignment: .top) {
                        // MARK: Main view
                        VStack(spacing: 40) {
                            HStack(spacing: 0) {
                                Spacer()
                                
                                VStack(spacing: 0) {
                                    Text("Current Speed:")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color.white)
                                    
                                    Text(String(currentSpeed))
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
                            }.opacity(tenSecondTimer ? 0 : 1)
                            
                            VStack(spacing: 0) {
                                Text("Time Remaining:")
                                    .font(Font.custom(fontHeaders, size: 16))
                                    .foregroundColor(Color("Energy Blue"))
                                Text(timeFormatted())
                                    .font(Font.custom("RobotoCondensed-Bold", size: 86))
                                    .foregroundColor(Color("Energy Blue"))
                            }.opacity(tenSecondTimer ? 0 : 1)
                        
                            HStack(spacing: -5){
                                Button(action: {
                                    if timeRemaining >= 5 {
                                        timeRemaining -= 5
                                    } else {
                                        timeRemaining = 0
                                    }
                                }) {
                                    Text("-5")
                                        .font(Font.custom("Roboto-Black", size: 35))
                                        .foregroundColor(Color.white)
                                }.disabled(isActive ? false : true)
                                    .frame(height: isActive ? 110 : 0)
                                    .padding(.leading, 10)
                                    .opacity(tenSecondTimer ? 0 : 1)
                                
                                Button(action: {
                                    returnToSettings = true
                                }) {
                                    Image("button_stop")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 86, height: 110)
                                        .opacity(isActive ? 0 : 1)
                                }.disabled(isActive ? true : false)
                                    .contentShape(Rectangle())
                               
                                Button(action: {
                                    
                                    timer.upstream.connect().cancel()
                                    timerVm.stop()
                                    locationManager.stopLocationUpdates()
                                    
                                    if tenSecondTimer {
                                        returnToSettings = true
                                    } else {
                                        isActive.toggle()
                                    }
                                    
                                }) {
                                    Image(tenSecondTimer ? "button_stop" : "button_pause")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 86, height: 110)
                                }.disabled(isActive ? false : true)
                                    .frame(height: isActive ? nil : 0)
                                
                                Button(action: {
                                    isActive.toggle()
                                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                    timerVm.start(seconds: timeRemaining)
                                    locationManager.resumeLocationUpdates()
                                }) {
                                    Image("button_play")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 86, height: 110)
                                        .opacity(isActive ? 0 : 1)
                                }.disabled(isActive ? true : false)
                                
                                Button(action: {
                                    timeRemaining += 5
                                }) {
                                    Text("+5")
                                        .font(Font.custom("Roboto-Black", size: 35))
                                        .foregroundColor(Color.white)
                                }.disabled(isActive ? false : true)
                                    .frame(height: isActive ? 110 : 0)
                                    .padding(.trailing, 10)
                                    .opacity(tenSecondTimer ? 0 : 1)
                            }
                        }
                        
                        // MARK: Countdown view
                        VStack {
                            ZStack {
                                Image("stopwatch")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 280, height: 300)
                                
                                Text(countdownTime())
                                    .font(Font.custom("Roboto-Black", size: 130))
                                    .foregroundColor(Color("Energy Blue"))
                                    .padding(.top, 40)
                                    .scaleEffect(smol ? 0.8 : 1.0, anchor: .center)
                            }
                            
                            Spacer()
                        }.opacity(tenSecondTimer ? 1 : 0)
                        
                    }
                }
            }.ignoresSafeArea()
                .preferredColorScheme(.dark)
                .onAppear() {
                    withAnimation(.easeIn) {
                        hideTab = true
                    }
                    
                    locationManager.resumeLocationUpdates()
                    
                    if tenSecondTimer {
                        timeRemaining = 10
                    } else {
                        GSAudio.sharedInstance.playSound(sound: .start_sound)
                        timeRemaining = Int(energy * 5 * 60) + 30
                    }
                    
                    timerVm.start(seconds: timeRemaining)
                    // to animate '10' on ten-second timer
                    smol = false
                    withAnimation(.easeInOut(duration: 1)) {
                        smol = true
                    }
                }
                .onReceive(timer, perform: { _ in
                    timerVm.updateCountdown()
                    updateTimer()
                })
        }
    }
    
    // returns footprint, trainer t, or bolt
    func getShoeResource() -> String {
        var resourceName: String
        
        switch shoeType {
        case "Trainer" :
            resourceName = "trainer_t"
        case "Custom" :
            resourceName = "bolt"
        default:
            resourceName = "footprint"
        }
        
        return resourceName
    }
    
    func updateTimer() {
        
        // MARK: GPS Accuracy
        gpsAccuracy = locationManager.userLocation?.horizontalAccuracy ?? 0.0
        
        if gpsAccuracy == 0 {
            gpsBars = 0
        } else if gpsAccuracy < 15 {
            gpsBars = 3
        } else if gpsAccuracy < 25 {
            gpsBars = 2
        } else {
            gpsBars = 1
        }
        
        if tenSecondTimer {
            smol = false
            withAnimation(.easeInOut(duration: 1)) {
                smol = true
            }
            if timeRemaining == 4 {
                Task {
                    await threeSecondCountdown()
                }
            }
            if timeRemaining == 1 {
                timeRemaining = Int(energy * 5 * 60) + 31
                timerVm.stop()
                timerVm.start(seconds: timeRemaining)
                tenSecondTimer = false
            }
            
            timeRemaining -= 1
            
        } else if timeRemaining > 0 {
            
            // MARK: Update current and average speeds
            currentSpeed = Double(round((locationManager.userLocation?.speed ?? 0.0) * 36) / 10)
            
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
            
            if currentSpeed < 1 {
                currentSpeed = 0.0
            }
            if currentAvgSpeed < 0 {
                currentAvgSpeed = 0.0
            }
            
            // MARK: Speed alarm
            if currentSpeed < minSpeed || currentSpeed > maxSpeed {
                if !justPlayed {
                    if currentSpeed < minSpeed {
                        // low-pitched alert
                         GSAudio.sharedInstance.playSound(sound: .alert_sound_slow)
                    } else {
                        // high-pitched alert
                         GSAudio.sharedInstance.playSound(sound: .alert_sound)
                    }
                    justPlayed = true
                } else {
                    justPlayed = false
                }
            }
            
            // MARK: Modify energy count
            if timeRemaining % 60 == 0 {
                energy = round(Double(timeRemaining) / 60 / 5 * 10) / 10
            }
                                    
            // MARK: Voice updates
            if timeRemaining % 300 == 0 &&
                (voiceAlertsTime || voiceAlertsCurrentSpeed || voiceAlertsAvgSpeed) {
                
                if voiceAlertsTime {
                    Task {
                        await playVoiceTime()
                    }
                } else if voiceAlertsCurrentSpeed {
                    Task {
                        await playVoiceCurrentSpeed()
                    }
                } else {
                    Task {
                        await playVoiceAvgSpeed()

                    }
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
            
            if timeRemaining == 4 {
                Task {
                    await threeSecondCountdown()
                }
            }
            
            timeRemaining -= 1
            
        } else {
            isActive = false
            timeRemaining = 0
            timer.upstream.connect().cancel()
            timerVm.stop()
            locationManager.stopLocationUpdates()
            returnToSettings = true
        }
    }
    
    // MARK: Time remaining voice func
    func playVoiceTime() async {
        var minConversion: Int = timeRemaining / 60 + 1
        var hourMillis: Double = 0
        
        // skips if time (somehow) greater than 3 hrs
        if minConversion < 180 {
            GSAudio.sharedInstance.playSound(sound: .time_remaining)
            
            if !isActive {
                return
            }
            
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
                
                if !isActive {
                    return
                }
                                
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
                    try await Task.sleep(nanoseconds: UInt64(480 * Double(NSEC_PER_MSEC)))
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

                if !isActive {
                    return
                }
                
                if voiceAlertsCurrentSpeed {
                    await playVoiceCurrentSpeed()
                } else if voiceAlertsAvgSpeed {
                    await playVoiceAvgSpeed()
                }

            } catch {
                print("i can't sleep :)")
            }
        }        
    }
    
    // MARK: Current speed voice func
    func playVoiceCurrentSpeed() async {
        GSAudio.sharedInstance.playSound(sound: .current_speed)
            
            do {
                try await Task.sleep(nanoseconds: UInt64(1100 * Double(NSEC_PER_MSEC)))
                
                if !isActive {
                    return
                }
                
                await needForSpeed(speed: currentSpeed)
                
                if voiceAlertsAvgSpeed {
                    try await Task.sleep(nanoseconds: UInt64(2000 * Double(NSEC_PER_MSEC)))
                    
                    if !isActive {
                        return
                    }
                    
                    await playVoiceAvgSpeed()
                }
            } catch {
                print("can't sleep bruh")
            }
    }
    
    // MARK: Average speed voice func
    func playVoiceAvgSpeed() async {
        GSAudio.sharedInstance.playSound(sound: .avg_speed)
            
            do {
                try await Task.sleep(nanoseconds: UInt64(1500 * Double(NSEC_PER_MSEC)))
                
                if !isActive {
                    return
                }
                
                await needForSpeed(speed: currentAvgSpeed)
            } catch {
                print("can't sleep bruh")
            }
    }
    
    // plays speed nums
    func needForSpeed(speed: Double) async {
        let speedOne = floor(speed)
        let speedTwo = Int((speed - speedOne) * 10)
        
        print("speed: \(speed)")
        print("Speed one: \(speedOne)")
        print("speed two: \(speedTwo)")
        
        do {
            switch speedOne {
            case 0:
                GSAudio.sharedInstance.playSound(sound: .zero)
                try await Task.sleep(nanoseconds: UInt64(430 * Double(NSEC_PER_MSEC)))
            case 1:
                GSAudio.sharedInstance.playSound(sound: .one)
                try await Task.sleep(nanoseconds: UInt64(270 * Double(NSEC_PER_MSEC)))
            case 2:
                GSAudio.sharedInstance.playSound(sound: .two)
                try await Task.sleep(nanoseconds: UInt64(270 * Double(NSEC_PER_MSEC)))
            case 3:
                GSAudio.sharedInstance.playSound(sound: .three)
                try await Task.sleep(nanoseconds: UInt64(240 * Double(NSEC_PER_MSEC)))
            case 4:
                GSAudio.sharedInstance.playSound(sound: .four)
                try await Task.sleep(nanoseconds: UInt64(260 * Double(NSEC_PER_MSEC)))
            case 5:
                GSAudio.sharedInstance.playSound(sound: .five)
                try await Task.sleep(nanoseconds: UInt64(300 * Double(NSEC_PER_MSEC)))
            case 6:
                GSAudio.sharedInstance.playSound(sound: .six)
                try await Task.sleep(nanoseconds: UInt64(320 * Double(NSEC_PER_MSEC)))
            case 7:
                GSAudio.sharedInstance.playSound(sound: .sevn)
                try await Task.sleep(nanoseconds: UInt64(380 * Double(NSEC_PER_MSEC)))
            case 8:
                GSAudio.sharedInstance.playSound(sound: .eight)
                try await Task.sleep(nanoseconds: UInt64(200 * Double(NSEC_PER_MSEC)))
            case 9:
                GSAudio.sharedInstance.playSound(sound: .nine)
                try await Task.sleep(nanoseconds: UInt64(320 * Double(NSEC_PER_MSEC)))
            case 10:
                GSAudio.sharedInstance.playSound(sound: .ten)
                try await Task.sleep(nanoseconds: UInt64(270 * Double(NSEC_PER_MSEC)))
            case 11:
                GSAudio.sharedInstance.playSound(sound: .eleven)
                try await Task.sleep(nanoseconds: UInt64(380 * Double(NSEC_PER_MSEC)))
            case 12:
                GSAudio.sharedInstance.playSound(sound: .twelve)
                try await Task.sleep(nanoseconds: UInt64(375 * Double(NSEC_PER_MSEC)))
            case 13:
                GSAudio.sharedInstance.playSound(sound: .thirteen)
                try await Task.sleep(nanoseconds: UInt64(465 * Double(NSEC_PER_MSEC)))
            case 14:
                GSAudio.sharedInstance.playSound(sound: .fourteen)
                try await Task.sleep(nanoseconds: UInt64(490 * Double(NSEC_PER_MSEC)))
            case 15:
                GSAudio.sharedInstance.playSound(sound: .fifteen)
                try await Task.sleep(nanoseconds: UInt64(640 * Double(NSEC_PER_MSEC)))
            case 16:
                GSAudio.sharedInstance.playSound(sound: .sixteen)
                try await Task.sleep(nanoseconds: UInt64(570 * Double(NSEC_PER_MSEC)))
            case 17:
                GSAudio.sharedInstance.playSound(sound: .seventeen)
                try await Task.sleep(nanoseconds: UInt64(600 * Double(NSEC_PER_MSEC)))
            case 18:
                GSAudio.sharedInstance.playSound(sound: .eighteen)
                try await Task.sleep(nanoseconds: UInt64(435 * Double(NSEC_PER_MSEC)))
            case 19:
                GSAudio.sharedInstance.playSound(sound: .nineteen)
                try await Task.sleep(nanoseconds: UInt64(480 * Double(NSEC_PER_MSEC)))
            case 20:
                GSAudio.sharedInstance.playSound(sound: .twenty)
                try await Task.sleep(nanoseconds: UInt64(200 * Double(NSEC_PER_MSEC)))
            default:
                GSAudio.sharedInstance.playSound(sound: .over_twenty)
                try await Task.sleep(nanoseconds: UInt64(630 * Double(NSEC_PER_MSEC)))
            }
            
            if !isActive {
                return
            }
            
            if speedOne <= 20 {
                GSAudio.sharedInstance.playSound(sound: .point)
                try await Task.sleep(nanoseconds: UInt64(250 * Double(NSEC_PER_MSEC)))
                
                switch speedTwo {
                    case 1:
                        GSAudio.sharedInstance.playSound(sound: .one)
                        try await Task.sleep(nanoseconds: UInt64(270 * Double(NSEC_PER_MSEC)))
                    case 2:
                        GSAudio.sharedInstance.playSound(sound: .two)
                        try await Task.sleep(nanoseconds: UInt64(270 * Double(NSEC_PER_MSEC)))
                    case 3:
                        GSAudio.sharedInstance.playSound(sound: .three)
                        try await Task.sleep(nanoseconds: UInt64(240 * Double(NSEC_PER_MSEC)))
                    case 4:
                        GSAudio.sharedInstance.playSound(sound: .four)
                        try await Task.sleep(nanoseconds: UInt64(260 * Double(NSEC_PER_MSEC)))
                    case 5:
                        GSAudio.sharedInstance.playSound(sound: .five)
                        try await Task.sleep(nanoseconds: UInt64(300 * Double(NSEC_PER_MSEC)))
                    case 6:
                        GSAudio.sharedInstance.playSound(sound: .six)
                        try await Task.sleep(nanoseconds: UInt64(320 * Double(NSEC_PER_MSEC)))
                    case 7:
                        GSAudio.sharedInstance.playSound(sound: .sevn)
                        try await Task.sleep(nanoseconds: UInt64(380 * Double(NSEC_PER_MSEC)))
                    case 8:
                        GSAudio.sharedInstance.playSound(sound: .eight)
                        try await Task.sleep(nanoseconds: UInt64(200 * Double(NSEC_PER_MSEC)))
                    case 9:
                        GSAudio.sharedInstance.playSound(sound: .nine)
                        try await Task.sleep(nanoseconds: UInt64(320 * Double(NSEC_PER_MSEC)))
                    default:
                        GSAudio.sharedInstance.playSound(sound: .zero)
                        try await Task.sleep(nanoseconds: UInt64(430 * Double(NSEC_PER_MSEC)))
                }
            }
            
            if !isActive {
                return
            }
            
            GSAudio.sharedInstance.playSound(sound: .kilo_per_hour)

        } catch {
            print("insomniac")
        }
        
    }
    
    func threeSecondCountdown() async {
        do {
            for _ in 1...3 {
                GSAudio.sharedInstance.playSound(sound: .soft_alert_sound)
                try await Task.sleep(nanoseconds: UInt64(0.9 * Double(NSEC_PER_SEC)))
            }
        } catch {
            print("3 second sleepah")
        }
        GSAudio.sharedInstance.playSound(sound: .start_sound)
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
    
    func countdownTime() -> String {
        return String(format: "%02i", timeRemaining)
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
            hideTab: .constant(true),
            shoeType: "Jogger",
            minSpeed: -2.0,
            maxSpeed: 20.0,
            energy: 2,
            tenSecondTimer: true,
            voiceAlertsCurrentSpeed: false,
            voiceAlertsAvgSpeed: false,
            voiceAlertsTime: false,
            voiceAlertsMinuteThirty: false)
    }
}
