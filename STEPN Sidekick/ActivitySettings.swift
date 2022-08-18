//
//  ContentView.swift
//  STEPN Sidekick
//
//  App start screen. Allows user to select a type of shoe from a list of default or
//  enter custom stats. User enters energy they want to spend and whether or not they
//  want to enable voice updates and the ten-second countdown timer. Starts the
//  SpeedTracker activity.
//
//  Created by Rob Godfrey
//  Last updated 14 Aug 22
//

//  TODO: deez
//    - persistance
//    - ads, eventually
//    - help dialogs
//    - nav bar (obvi)
//    - set max energy (so screen doesn't shift down w/ large energy)
//    - remove all print statements

import SwiftUI

// for speed voice alerts
private let speedAlertsDisabled: Int = 0
private let speedAlertsCurrent: Int = 1
private let speedAlertsAverage: Int = 2
private let speedAlertsBoth: Int = 3

struct ActivitySettings: View {
    
    @State private var noEnergyAlert: Bool = false
    @State private var startSpeedTracker: Bool = false
    @State private var energySelected: Bool = false
    
    // TODO change all these bad boys to load saved values
    @State private var tenSecondTimer: Bool = true
    @State private var voiceAlertsSpeedType: Int = speedAlertsBoth
    @State private var voiceAlertsTime: Bool = true
    @State private var voiceAlertsMinThirty: Bool = true
    @State private var energy: Double = 2.0
    @State private var shoeTypeIterator: Int = walker
    @State private var customMinSpeed: Float = 0
    @State private var customMaxSpeed: Float = 0
    @State private var firstTime: Bool = true
    @State private var savedAppVersion: Float = 1.0
    
    // delete?
    @State private var minSpeedString = "1.0"
    @State private var maxSpeedString = "6.0"
    @State private var energyString = ""
    
    // TODO: load custom values for custom shoe
    @State private var shoes: [Shoe] = [
        Shoe(title: "Walker", imageResource: "shoe_walker", footResource: "footprint", minSpeed: 1.0, maxSpeed: 6.0),
        Shoe(title: "Jogger", imageResource: "shoe_jogger", footResource: "footprint", minSpeed: 4.0, maxSpeed: 10.0),
        Shoe(title: "Runner", imageResource: "shoe_runner", footResource: "footprint", minSpeed: 8.0, maxSpeed: 20.0),
        Shoe(title: "Trainer", imageResource: "shoe_trainer", footResource: "trainer_t", minSpeed: 1.0, maxSpeed: 20.0),
        Shoe(title: "Custom", imageResource: "shoe_custom", footResource: "bolt", minSpeed: 0, maxSpeed: 0)
    ]
                
    var body: some View {
                
        VStack {
            if startSpeedTracker {
                SpeedTracker(
                    shoeType: shoes[shoeTypeIterator].getTitle(),
                    minSpeed: shoes[shoeTypeIterator].getMinSpeed(),
                    maxSpeed: shoes[shoeTypeIterator].getMaxSpeed(),
                    energy: energy,
                    tenSecondTimer: tenSecondTimer,
                    voiceAlertsCurrentSpeed:
                        (voiceAlertsSpeedType == speedAlertsCurrent || voiceAlertsSpeedType == speedAlertsBoth) ? true : false,
                    voiceAlertsAvgSpeed:
                        (voiceAlertsSpeedType == speedAlertsAverage || voiceAlertsSpeedType == speedAlertsBoth) ? true : false,
                    voiceAlertsTime: voiceAlertsTime,
                    voiceAlertsMinuteThirty: voiceAlertsMinThirty)
            } else {
                //NavigationView {
                    ZStack(alignment: .top) {
                        Color("Background Almost White")
                        VStack(spacing: 0){
                            Rectangle()
                                .foregroundColor(Color("Light Green"))
                                .frame(width: UIScreen.main.bounds.width, height: 30)
                                    
                        ScrollView {
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color("Light Green"))
                                        .frame(width: UIScreen.main.bounds.width)
                                        .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                                    
                                    VStack(spacing: 0) {
                                        ZStack {
                                            
                                            Image("main_box")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(12)
                                                .frame(minWidth: 140, maxWidth: 420, minHeight: 100, maxHeight: 300)
                                                .background(Color("Light Green"))
                                                .cornerRadius(/*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                                .overlay(
                                                    HStack(spacing: 0) {
                                                        Image("footprint")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: shoeTypeIterator == runner ? 10 : 0, height: 16)
                                                            .padding(.bottom, 26)
                                                        
                                                        Image("footprint")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: shoeTypeIterator == runner || shoeTypeIterator == jogger ? 10 : 0, height: 16)
                                                            .padding(.bottom, 26)
                                                        
                                                        Image(shoes[shoeTypeIterator].getFootResource())
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(minWidth: 10, maxWidth: (shoeTypeIterator == trainer ? 16 : 10), minHeight: 10, maxHeight: 16)
                                                            .padding(.bottom, 26)
                                                            .padding(.trailing, 4)
                                                        
                                                        Text(shoes[shoeTypeIterator].getTitle())
                                                            .font(Font.custom(fontButtons, size: 16))
                                                            .foregroundColor(Color("Almost Black"))
                                                            .padding(.bottom, 26)
                                                
                                                }, alignment: .bottom)
                                                .overlay(

                                                ZStack {
                                                    Circle()
                                                        .fill(Color("Almost Black"))
                                                        .frame(width: 46, height: 36)
                                                        .padding([.leading, .top], 2)

                                                    
                                                    Button(action: {
                                                        print("help me")

                                                    }) {
                                                        Circle()
                                                            .strokeBorder(Color("Almost Black"), lineWidth: 1)
                                                            .background(Circle().fill(Color("Help Button Orange")))
                                                            .frame(width: 46, height: 36)
                                                            .padding()
                                                    }
                                                    
                                                    Text("?")
                                                        .font(Font.custom(fontTitles, size: 16))
                                                        .foregroundColor(Color("Almost Black"))
                                                }
                                                    .padding(.top, 4)
                                                    .padding(.trailing, 8), alignment: .topTrailing)
                                                
                                            Image(shoes[shoeTypeIterator].getImageResource())
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(minWidth: 120, maxWidth: 168, minHeight: 120, maxHeight: 168)
                                                .padding(.trailing, 4)
                                                .padding(.bottom, 28)
                                            
                                            HStack(spacing: 200) {
                                                Button(action: {
                                                    if shoeTypeIterator == customShoe {
                                                        shoes[customShoe].setMinSpeed(Double(minSpeedString) ?? 0)
                                                        shoes[customShoe].setMaxSpeed(Double(maxSpeedString) ?? 0)
                                                    }
                                                    
                                                    if shoeTypeIterator == walker {
                                                        shoeTypeIterator = customShoe
                                                    } else {
                                                        shoeTypeIterator -= 1
                                                    }
                                                
                                                    minSpeedString = (shoes[shoeTypeIterator].getMinSpeed() == 0 ? "" : String(shoes[shoeTypeIterator].getMinSpeed()))
                                                    maxSpeedString = (shoes[shoeTypeIterator].getMaxSpeed() == 0 ? "" : String(shoes[shoeTypeIterator].getMaxSpeed()))
                                                }) {
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                }.frame(width: 80, height: 100)
                                                
                                                Button(action: {
                                                    if shoeTypeIterator == customShoe {
                                                        shoes[customShoe].setMinSpeed(Double(minSpeedString) ?? 0)
                                                        shoes[customShoe].setMaxSpeed(Double(maxSpeedString) ?? 0)
                                                        shoeTypeIterator = walker
                                                    } else {
                                                        shoeTypeIterator += 1
                                                    }
                                                    
                                                    minSpeedString = (shoes[shoeTypeIterator].getMinSpeed() == 0 ? "" : String(shoes[shoeTypeIterator].getMinSpeed()))
                                                    maxSpeedString = (shoes[shoeTypeIterator].getMaxSpeed() == 0 ? "" : String(shoes[shoeTypeIterator].getMaxSpeed()))
                                                }) {
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                }.frame(width: 80, height: 100)
                                            }
                                        }.frame(width: UIScreen.main.bounds.width-20, alignment: .center)

                                    }
                                }
                                
                                ZStack {
                                    
                                    Button(action: {
                                        UIApplication.shared.hideKeyboard()
                                    }) {
                                        Color("Background Almost White")
                                    }
                                    
                            
                                    VStack(spacing: 0) {
                                        Text("SETTINGS")
                                            .font(Font.custom(fontTitles, size: 28))
                                            .padding(12)
                                        
                                        HStack(spacing: 0) {
                                            Spacer()
                                        
                                            VStack(spacing: 0){
                                                Text("Minimum Speed")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {

                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .padding([.top, .leading], 5)
                                                    
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(shoeTypeIterator == customShoe ? .white : Color("Button Disabled"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color("Almost Black"), lineWidth: 1.4)
                                                            )

                                                    Text("km/h")
                                                        .padding(.trailing, 12)
                                                        .padding(.top, 4)
                                                        .font(Font.custom(fontTitles, size: 15))
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48, alignment: .trailing)
                                                    
                                                    TextField("0.0", text: $minSpeedString)
                                                        .padding(.trailing, 6)
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .font(Font.custom(fontTitles, size: 22))
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                                                        .onReceive(minSpeedString.publisher.collect()) {
                                                            self.minSpeedString = String($0.prefix(4))
                                                        }
                                                        .disabled(shoeTypeIterator != customShoe)
                                                }
                                            }
                                            Spacer()
                                            
                                            VStack(spacing: 0) {
                                                Text("Maximum Speed")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {

                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .padding([.top, .leading], 5)
                                                    
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(shoeTypeIterator == customShoe ? .white : Color("Button Disabled"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color("Almost Black"), lineWidth: 1.4)
                                                        )
                                                    
                                                    Text("km/h")
                                                        .padding(.trailing, 12)
                                                        .padding(.top, 4)
                                                        .font(Font.custom(fontTitles, size: 15))
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48, alignment: .trailing)

                                                    TextField("0.0", text: $maxSpeedString)
                                                        .padding(.trailing, 6)
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .font(Font.custom(fontTitles, size: 22))
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .keyboardType(.decimalPad)
                                                        .onReceive(maxSpeedString.publisher.collect()) {
                                                            self.maxSpeedString = String($0.prefix(4))
                                                        }
                                                        .disabled(shoeTypeIterator != customShoe)
                                                    
                                                }
                                                
                                            }
                                            
                                            Spacer()

                                        }.frame(width: UIScreen.main.bounds.width-20, height: 78, alignment: .center)
                                        
                                        HStack(spacing: 0) {
                                            Spacer()
                                        
                                            VStack(spacing: 0) {
                                                Text("Countdown Timer")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                    .padding(.top, 5.0)
                                                
                                                ZStack {
                                                
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .padding([.top, .leading], 5)
                                                    
                                                    Button(action: {
                                                        tenSecondTimer = !tenSecondTimer
                                                        UIApplication.shared.hideKeyboard()
                                                        print("Tec second timer " + (tenSecondTimer ? "on" : "off"))
                                                    }) {
                                                        Text(tenSecondTimer == true ? "ENABLED" : "DISABLED")
                                                            .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)

                                                    }
                                                        .buttonStyle(MainButtons(enabled: tenSecondTimer,
                                                            tapAction: {
                                                                tenSecondTimer = !tenSecondTimer
                                                                UIApplication.shared.hideKeyboard()
                                                                print("Tec second timer " + (tenSecondTimer ? "on" : "off"))
                                                            }
                                                        ))
                                                        .font(Font.custom(fontButtons, size: 20))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(spacing: 0) {
                                                Text("Energy to Spend")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                    .padding(.top, 5.0)
                                                
                                                ZStack {

                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Energy Blue Border"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .padding([.top, .leading], 5)
                                                    
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(energySelected ? Color("Energy Blue Lighter") : Color("Energy Blue"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color("Energy Blue Border"), lineWidth: 1.4)
                                                        )
                                                    
                                                    Image("energy_bolt")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(.trailing, 28)
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 20, maxHeight: 24, alignment: .trailing)
                                                
                                                    TextField("0.0", text: $energyString, onEditingChanged: { (editingChanged) in
                                                        if editingChanged {
                                                            energySelected = true
                                                        } else {
                                                            energySelected = false                                                                   }
                                                        })
                                                        .padding(.trailing, 6)
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .font(Font.custom(fontTitles, size: 22))
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .keyboardType(.decimalPad)
                                                        .onReceive(energyString.publisher.collect()) {
                                                            self.energyString = String($0.prefix(4))
                                                        }
                                                        
                                                }
                                            }

                                            Spacer()
                                            
                                        }.frame(width: UIScreen.main.bounds.width-20, height: 78, alignment: .center)
                                        
                                        HStack(spacing: 0) {
                                            Spacer()

                                            Rectangle()
                                                .frame(minWidth: 150, maxWidth: 157, maxHeight: 0)
                                            
                                            Spacer()
                                            
                                            Text(getMinString(energy: Double(energyString) ?? 0.0))
                                                .font(Font.custom(fontButtons, size: 16))
                                                .foregroundColor(Color("Gandalf"))
                                                .frame(minWidth: 150, maxWidth: 160)
                                            
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width-20, alignment: .center)
                                        
                                        Text("VOICE UPDATES")
                                            .font(Font.custom(fontTitles, size: 24))
                                            .padding(12)
                                        
                                        HStack(spacing: 4) {
                                            VStack(spacing: 0) {
                                                Text("Speed")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                        .padding([.top, .leading], 5)
                                                
                                                
                                                    Button(action: {
                                                        if voiceAlertsSpeedType == speedAlertsBoth {
                                                            voiceAlertsSpeedType = speedAlertsDisabled
                                                        } else {
                                                            voiceAlertsSpeedType += 1
                                                        }
                                                        UIApplication.shared.hideKeyboard()
                                                        print("Speed alerts button changed")
                                                    }, label: {
                                                        Text(voiceSpeedText())
                                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    })
                                                    .buttonStyle(MainButtons(enabled: voiceAlertsSpeedType != 0,
                                                        tapAction: {
                                                            if voiceAlertsSpeedType == speedAlertsBoth {
                                                                voiceAlertsSpeedType = speedAlertsDisabled
                                                            } else {
                                                                voiceAlertsSpeedType += 1
                                                            }
                                                            print("Speed alerts button changed")
                                                            UIApplication.shared.hideKeyboard()
                                                        }
                                                    ))
                                                    .font(Font.custom(fontButtons, size: 17))
                                                }
                                            }
                                
                                        
                                            VStack(spacing: 0) {
                                                Text("Time")
                                                    .font(Font.custom(fontHeaders, size: 15))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                        .padding([.top, .leading], 5)
                                                
                                                    Button(action: {
                                                        voiceAlertsTime = !voiceAlertsTime
                                                        print("Time alerts button switched")
                                                        UIApplication.shared.hideKeyboard()
                                                    }) {
                                                        Text(voiceAlertsTime == true ? "ENABLED" : "DISABLED")
                                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)

                                                    }
                                                    .buttonStyle(MainButtons(enabled: voiceAlertsTime,
                                                            tapAction: {
                                                                voiceAlertsTime = !voiceAlertsTime
                                                                print("Time alerts button switched")
                                                                UIApplication.shared.hideKeyboard()
                                                            }
                                                        ))
                                                        .font(Font.custom(fontButtons, size: 17))
                                                }
                                            }
                                            
                                            VStack(spacing: 0){
                                                Text("1 min / 30 sec")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                        .padding([.top, .leading], 5)


                                                    Button(action: {
                                                        voiceAlertsMinThirty = !voiceAlertsMinThirty
                                                        print("1 min / 30 sec button switched")
                                                        UIApplication.shared.hideKeyboard()
                                                    }) {
                                                        Text(voiceAlertsMinThirty == true ? "ENABLED" : "DISABLED")
                                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    }
                                                        .buttonStyle(MainButtons(enabled: voiceAlertsMinThirty,
                                                            tapAction: {
                                                                voiceAlertsMinThirty = !voiceAlertsMinThirty
                                                                print("1 min / 30 sec button switched")
                                                                UIApplication.shared.hideKeyboard()
                                                            }))
                                                        .font(Font.custom(fontButtons, size: 17))
                                                }
                                            }
                                        }
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(minWidth: 165, maxWidth: 165, minHeight: 50, maxHeight: 50)
                                                .padding(.top, 8)
                                                .padding(.leading, 6)
                                            
                                            Button(action: {
                                                if shoeTypeIterator == customShoe {
                                                    shoes[customShoe].setMinSpeed(Double(minSpeedString) ?? 0)
                                                    shoes[customShoe].setMaxSpeed(Double(maxSpeedString) ?? 0)
                                                }
                                                if Double(energyString) ?? 0 == 0 {
                                                    noEnergyAlert = true
                                                } else {
                                                    energy = Double(energyString) ?? 0.2
                                                    self.startSpeedTracker = true
                                                }
                                                
                                            } ) {
                                                Text("START")
                                                    .frame(width: 165, height: 50)

                                            }
                                                .buttonStyle(StartButton(tapAction: {
                                                    if shoeTypeIterator == customShoe {
                                                        shoes[customShoe].setMinSpeed(Double(minSpeedString) ?? 0)
                                                        shoes[customShoe].setMaxSpeed(Double(maxSpeedString) ?? 0)
                                                    }
                                                    if Double(energyString) ?? 0 == 0 {
                                                        noEnergyAlert = true
                                                    } else {
                                                        energy = Double(energyString) ?? 0.2
                                                        self.startSpeedTracker = true
                                                    }
                                                }))
                                                .font(Font.custom(fontButtons, size: 25))
                                            
                                        }.padding(.vertical, 38)
                                    }
                                }
                            }
                        }
                        
                    }.ignoresSafeArea()
                    .padding(.horizontal, -38)
                    .frame(width: UIScreen.main.bounds.width-20, alignment: .center)
                
             // nav view closing bracket  }
            }
        }
        .alert(isPresented: $noEnergyAlert) {
            Alert(title: Text("Check Energy"), message: Text("Energy must be greater than 0"), dismissButton: .default(Text("Okay")))
        }
    }
    
    func voiceSpeedText() -> String {
        var buttonText: String
        switch voiceAlertsSpeedType {
        case speedAlertsDisabled:
            buttonText = "DISABLED"
        case speedAlertsCurrent:
            buttonText = "CURRENT"
        case speedAlertsAverage:
            buttonText = "AVERAGE"
        default:
            buttonText = "ALL"
        }
        return buttonText
    }
    
    func getMinString(energy: Double) -> String {
        var energyInMins: Int = Int(energy * 5)
        var minString: String
        
        if energyInMins == 0 {
            minString = "(0 mins)"
        } else if energyInMins < 60 {
            minString = "(\(energyInMins) " + (energyInMins < 2 ? "min 30 sec)" : "mins 30 sec)")
        } else {
            let hours: Int = Int(floor(Double(energyInMins) / 60.0))
            minString = "(\(hours) " + (hours < 2 ? "hour" : "hours")
            energyInMins = energyInMins - (hours * 60)
            if energyInMins > 0 {
                minString += " \(energyInMins) " + (energyInMins < 2 ? "min 30 sec)" : "mins 30 sec)")
            } else {
                minString += " 30 sec)"
            }
        }
        return minString
    }
}

struct MainButtons: ButtonStyle {
    @State private var isLongPressing = false
    let enabled: Bool
    let tapAction: (()->())
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            configuration.label
                .foregroundColor(Color("Almost Black"))
                .background(enabled ? Color("Button Green") : Color("Button Disabled"))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("Almost Black"), lineWidth: 1.4))
                .offset(x: isLongPressing ? 2 : 0, y: isLongPressing ? 2 : 0)
                .onLongPressGesture(minimumDuration: 1.0, pressing: { isPressing in
                    withAnimation(.easeInOut(duration: 0.0)) {
                        isLongPressing = isPressing
                    }
                }, perform: { })
                .simultaneousGesture(
                  TapGesture()
                    .onEnded { _ in
                        tapAction()
                    }
                )
        }
            
    }

}

struct StartButton: ButtonStyle {
    @State private var isLongPressing = false
    let tapAction: (()->())
    
    func makeBody(configuration: Configuration) -> some View {

        ZStack {

            configuration.label
                .background(Color("Button Green"))
                .foregroundColor(Color("Almost Black"))
                .cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("Almost Black"), lineWidth: 2))
                .offset(x: isLongPressing ? 2 : 0, y: isLongPressing ? 2 : 0)
                .onLongPressGesture(minimumDuration: 1.0, pressing: { isPressing in
                    withAnimation(.easeInOut(duration: 0.0)) {
                        isLongPressing = isPressing
                    }
                }, perform: { })
                .simultaneousGesture(
                  TapGesture()
                    .onEnded { _ in
                        tapAction()
                    }
                )
        }
    }

}

#if canImport(UIKit)
extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySettings()
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
