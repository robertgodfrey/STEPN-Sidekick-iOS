//
//  ActivitySettings.swift
//  STEPN Sidekick
//
//  App start screen. Allows user to select a type of shoe from a list of default or
//  enter custom stats. User enters energy they want to spend and whether or not they
//  want to enable voice updates and the ten-second countdown timer. Starts the
//  SpeedTracker activity.
//
//  Created by Rob Godfrey
//  Last updated 3 Sep 22
//

import SwiftUI

// for speed voice alerts
private let speedAlertsDisabled: Int = 0
private let speedAlertsCurrent: Int = 1
private let speedAlertsAverage: Int = 2
private let speedAlertsBoth: Int = 3

struct ActivitySettings: View {
    
    @Binding var hideTab: Bool

    // loaded from user defaults
    @AppStorage("savedAppVersion") private var savedAppVersion: Double = 1.0
    @AppStorage("tenSecondTimer") private var tenSecondTimer: Bool = true
    @AppStorage("voiceAlertsSpeedType") private var voiceAlertsSpeedType: Int = speedAlertsBoth
    @AppStorage("voiceAlertsTime") private var voiceAlertsTime: Bool = true
    @AppStorage("voiceAlertsMinThirty") private var voiceAlertsMinThirty: Bool = true
    @AppStorage("energy") private var energy: String = ""
    @AppStorage("shoeTypeIterator") private var shoeTypeIterator: Int = walker
    @AppStorage("customMinSpeed") private var customMinSpeed: String = ""
    @AppStorage("customMaxSpeed") private var customMaxSpeed: String = ""
    @AppStorage("firstTime") private var firstTime: Bool = true
        
    @State private var minSpeedString = ""
    @State private var maxSpeedString = ""
    
    @State private var startSpeedTracker: Bool = false
    @State private var startLocationRequest: Bool = false
    
    @State private var energySelected: Bool = false
    @State private var houstonWeHaveAProblem: Bool = false  // alert
    @State private var halp: Bool = false   // help dialogs
    @State private var helperCircles: Bool = false
    @State private var biggah: Bool = false
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
            
    @State private var shoes: [Shoe] = [
        Shoe(title: "Walker", imageResource: "shoe_walker", footResource: "footprint", minSpeed: "1.0", maxSpeed: "6.0"),
        Shoe(title: "Jogger", imageResource: "shoe_jogger", footResource: "footprint", minSpeed: "4.0", maxSpeed: "10.0"),
        Shoe(title: "Runner", imageResource: "shoe_runner", footResource: "footprint", minSpeed: "8.0", maxSpeed: "20.0"),
        Shoe(title: "Trainer", imageResource: "shoe_trainer", footResource: "trainer_t", minSpeed: "1.0", maxSpeed: "20.0"),
        Shoe(title: "Custom", imageResource: "shoe_custom", footResource: "bolt", minSpeed: "", maxSpeed: "")
    ]
    
    init(hideTab: Binding<Bool>) {
        self._hideTab = hideTab
        _minSpeedString = State(initialValue: shoes[shoeTypeIterator].getMinSpeed())
        _maxSpeedString = State(initialValue: shoes[shoeTypeIterator].getMaxSpeed())
    }
    
    var body: some View {
        ZStack {
            if startSpeedTracker {
                SpeedTracker(
                    hideTab: $hideTab,
                    shoeType: shoes[shoeTypeIterator].getTitle(),
                    minSpeed: shoeTypeIterator == customShoe ? Double(customMinSpeed) ?? 1.0 : Double(shoes[shoeTypeIterator].getMinSpeed()) ?? 1.0,
                    maxSpeed: shoeTypeIterator == customShoe ? Double(customMaxSpeed) ?? 6.0 :Double(shoes[shoeTypeIterator].getMaxSpeed()) ?? 6.0,
                    energy: Double(energy) ?? 0.2,
                    tenSecondTimer: tenSecondTimer,
                    voiceAlertsCurrentSpeed:
                        (voiceAlertsSpeedType == speedAlertsCurrent || voiceAlertsSpeedType == speedAlertsBoth) ? true : false,
                    voiceAlertsAvgSpeed:
                        (voiceAlertsSpeedType == speedAlertsAverage || voiceAlertsSpeedType == speedAlertsBoth) ? true : false,
                    voiceAlertsTime: voiceAlertsTime,
                    voiceAlertsMinuteThirty: voiceAlertsMinThirty)
                    .transition(.move(edge: .bottom))
                
            } else if startLocationRequest {
                LocationRequestView(hideTab: $hideTab)
                
            } else {
                ZStack(alignment: .top) {
                    Color("Background Almost White")
                    
                    VStack(spacing: 0){
                        Rectangle()
                            .foregroundColor(Color("Light Green"))
                            .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
                                    
                        ScrollView {
                            VStack {
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
                                                                                                      
                                                    Circle()
                                                        .strokeBorder(Color("Almost Black"), lineWidth: 1)
                                                        .background(Circle().fill(Color("Help Button Orange")))
                                                        .frame(width: 46, height: 36)
                                                        .padding()
                                                        .onTapGesture {
                                                            halp = true
                                                            withAnimation {
                                                                helperCircles = true
                                                            }
                                                            Task {
                                                                await delayCircles()
                                                            }
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
                                            
                                            HStack(spacing: 160) {
                                                Circle()
                                                    .foregroundColor(.yellow)
                                                    .opacity(0.4)
                                                    .scaleEffect(biggah ? 1.2 : 1)
                                                
                                                Circle()
                                                    .foregroundColor(.yellow)
                                                    .opacity(0.4)
                                                    .scaleEffect(biggah ? 1.2 : 1)
                                            }.padding(.bottom, 20)
                                                .opacity(helperCircles ? 1 : 0)
                                            
                                            HStack(spacing: 200) {
                                                Button(action: {
                                                    if shoeTypeIterator == walker {
                                                        shoeTypeIterator = customShoe
                                                    } else {
                                                        shoeTypeIterator -= 1
                                                    }
                                                    minSpeedString = shoes[shoeTypeIterator].getMinSpeed()
                                                    maxSpeedString = shoes[shoeTypeIterator].getMaxSpeed()
                                                }) {
                                                    Rectangle()
                                                        .fill(Color.clear)
                                                }.frame(width: 80, height: 100)
                                                
                                                Button(action: {
                                                    if shoeTypeIterator == customShoe {
                                                        shoeTypeIterator = walker
                                                    } else {
                                                        shoeTypeIterator += 1
                                                    }
                                                    minSpeedString = shoes[shoeTypeIterator].getMinSpeed()
                                                    maxSpeedString = shoes[shoeTypeIterator].getMaxSpeed()
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
                                        withAnimation(.easeOut .speed(1.5)) {
                                            hideTab = false
                                        }
                                    }) {
                                        Color("Background Almost White")
                                    }
                                    
                            
                                    VStack(spacing: 0) {
                                        Text("SETTINGS")
                                            .font(Font.custom(fontTitles, size: 28))
                                            .padding(8)
                                        
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
                                                    
                                                    TextField("0.0", text: (shoeTypeIterator == customShoe ? $customMinSpeed : $minSpeedString))
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

                                                    TextField("0.0", text: (shoeTypeIterator == customShoe ? $customMaxSpeed : $maxSpeedString))
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
                                                
                                                    TextField("0.0", text: $energy, onEditingChanged: { (editingChanged) in
                                                        if editingChanged {
                                                            energySelected = true
                                                            withAnimation(.easeOut .speed(1.5)) {
                                                                hideTab = true
                                                            }
                                                        } else {
                                                            energySelected = false                                                                   }
                                                        })
                                                        .padding(.trailing, 6)
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                                        .font(Font.custom(fontTitles, size: 22))
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .keyboardType(.decimalPad)
                                                        .onReceive(energy.publisher.collect()) {
                                                            self.energy = String($0.prefix(4))
                                                            if Double(energy) ?? 0 > 25 {
                                                                energy = "25"
                                                            }
                                                        }
                                                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                                                        if let textField = obj.object as? UITextField {
                                                                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                                                                        }
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
                                            
                                            Text(getMinString(energy: Double(energy) ?? 0.0))
                                                .font(Font.custom(fontButtons, size: 16))
                                                .foregroundColor(Color("Gandalf"))
                                                .frame(minWidth: 150, maxWidth: 160)
                                            
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width-20, alignment: .center)
                                        
                                        Text("VOICE UPDATES")
                                            .font(Font.custom(fontTitles, size: 24))
                                            .padding(8)
                                        
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
                                                withAnimation(.easeIn(duration: 0.2)) {
                                                    startin()
                                                }
                                            } ) {
                                                Text("START")
                                                    .frame(width: 165, height: 50)

                                            }
                                                .buttonStyle(StartButton(tapAction: {
                                                    withAnimation(.easeIn(duration: 0.2)) {
                                                        startin()
                                                    }
                                                }))
                                                .font(Font.custom(fontButtons, size: 25))
                                            
                                        }
                                        .padding(.top, 38)
                                        .padding(.bottom, 85)
                                    }
                                }
                            }
                            .overlay(
                                GeometryReader { proxy -> Color in
                                    let minY = proxy.frame(in: .global).minY
                                                                            
                                    DispatchQueue.main.async {
                                        if minY < offset {
                                            if offset < 0 && -minY > lastOffset + 40 {
                                                withAnimation(.easeOut .speed(1.5)) {
                                                    hideTab = true
                                                }
                                                
                                                lastOffset = -offset
                                            }
                                        }
                                        
                                        if minY > offset && -minY < lastOffset - 40 {
                                            withAnimation(.easeOut .speed(1.5)) {
                                                hideTab = false
                                            }
                                            
                                            lastOffset = -offset
                                        }
                                        self.offset = minY
                                    }
                                    
                                    return Color.clear
                                }
                                
                            )
                        }
                    }
                    
                }.ignoresSafeArea()
                .preferredColorScheme(.light)
                .padding(.horizontal, -38)
                .frame(maxWidth: UIScreen.main.bounds.width-20, maxHeight: .infinity, alignment: .center)
                
                if halp {
                    GeometryReader { _ in
                        Popup(show: $halp, circles: $helperCircles)
                    }
                }
                if firstTime {
                    GeometryReader { _ in
                        Welcome(show: $firstTime, halp: $halp, circles: $helperCircles)
                    }
                }
            }
        }
        .alert(isPresented: $houstonWeHaveAProblem) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("Okay")))
        }
    }
    
    func startin() {
        if Double(energy) ?? 0 == 0
            || Int((Double(energy) ?? 0) * 10) % 2 != 0
            || shoeTypeIterator == customShoe &&
                (Double(customMinSpeed) ?? 0 < 1 || Double(customMaxSpeed) ?? 0 < (Double(customMinSpeed) ?? 0) + 1) {
            
            if Double(energy) ?? 0 == 0 {
                alertTitle = "Check Energy"
                alertMessage = "Energy must be greater than 0"
            } else if Int((Double(energy) ?? 0) * 10) % 2 != 0 {
                alertTitle = "Check Energy"
                alertMessage = "Energy must be a mutliple of 0.2"
            } else if Double(customMinSpeed) ?? 0 < 1 {
                alertTitle = "Check Min Speed"
                alertMessage = "Minimum speed must be at least 1.0 km/h"
            } else if Double(customMaxSpeed) ?? 0 < (Double(customMinSpeed) ?? 0) + 1 {
                    alertTitle = "Check Custom Speeds"
                    alertMessage = "Maximum speed must be at least 1.0 km/h greater than minimum speed"
            } else {
                alertTitle = "Check Inputs"
                alertMessage = "Inputs must be greater than 0"
            }
            houstonWeHaveAProblem = true
        } else {
            @ObservedObject var locationManager = LocationManager.shared
            
            locationManager.checkAuth()
            
            if !locationManager.authorizedLocation {
                self.startLocationRequest = true
            } else {
                self.startSpeedTracker = true
            }
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
    
    func delayCircles() async {
        for _ in 1...10 {
            if !halp {
                break
            }
            withAnimation(.linear(duration: 1)) {
                biggah = true
            }
            try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            if !halp {
                break
            }
            withAnimation(.linear(duration: 1)) {
                biggah = false
            }
            try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        }
        withAnimation {
            helperCircles = false
        }
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
        ActivitySettings(hideTab: .constant(false))
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

struct Popup: View {
    
    @Binding var show: Bool
    @Binding var circles: Bool
    @State private var pageNum: Int = 1
    @State private var nextButton: String = "NEXT"
    @State private var details: String = "Use the arrows to select a shoe. You can use one of the default shoes or you can select \"Custom\" to input custom speeds. The app will play a warning sound if your current speed falls outside of the speed range that you choose."
    @State private var topPadding: CGFloat = 250
    @State private var bottomPadding: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.clear, .black, .clear]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .frame(maxHeight: 400)
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
    
            VStack(alignment: .leading) {
                Text("\(pageNum)/5")
                    .font(Font.custom(fontTitles, size: 16))
                    .foregroundColor(Color("Gandalf"))
                    .multilineTextAlignment(.leading)
                
                Text(details)
                    .font(Font.custom("Roboto-Regular", size: 17))
                    .foregroundColor(Color("Almost Black"))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1)
                    .padding(.bottom, 10)
                
                HStack {
                    Button(action: {
                        withAnimation(.linear(duration: 0.5)) {
                            show = false
                            circles = false
                        }
                    }, label: {
                        Text("SKIP >")
                    })
                    .font(Font.custom(fontHeaders, size: 15))
                    .opacity(pageNum == 5 ? 0 : 1)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(Color("Almost Black"))
                            .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                        
                        Button(action: {
                            print("Next button pressed")
                        }, label: {
                            Text(nextButton)
                                .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                        })
                            .buttonStyle(StartButton(tapAction: {
                                print("Next button pressed")
                                switch pageNum {
                                case 1:
                                    withAnimation {
                                        details = "Enter the amount of energy you wish to spend. The amount of time required to spend the energy will be displayed below."
                                        circles = false
                                        topPadding = 100
                                        pageNum += 1
                                    }
                                case 2:
                                    withAnimation {
                                        details = "Select whether or not the ten-second countdown timer is enabled. If enabled, this timer givers you GPS time to sync and gives you time to switch to the STEPN app to start your activity. If disabled, the app will start the activity timer immediately."
                                        topPadding = 80
                                        pageNum += 1
                                    }
                                case 3:
                                    withAnimation {
                                        details = "Select whether or not voice updates are enabled. The \"Speed\" and \"Time\" alerts will sound every five minutes, updating you with the amount of time remaining and information about your speed. The \"1 min / 30 sec\" alert gives a warning when you have one minute remaining and another warning at thirty seconds."
                                        pageNum += 1
                                        topPadding = 150
                                    }
                                case 4:
                                    withAnimation {
                                        details = "Press the start button to start your activity. Happy earning!"
                                        pageNum += 1
                                        nextButton = "GO"
                                        topPadding = 150
                                    }
                                default:
                                    show = false
                                }
                            }
                            ))
                            .font(Font.custom(fontButtons, size: 20))
                    }
                }
            }   .padding(20)
                .frame(maxWidth: 310)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
        }.ignoresSafeArea()
    }
}

struct Welcome: View {
    
    @Binding var show: Bool
    @Binding var halp: Bool
    @Binding var circles: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.clear, .black, .clear]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .frame(maxHeight: 400)
                .padding(.top, 100)
    
            
            VStack {
                Text("WELCOME!")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Gandalf"))
                
                Text("Please view these brief instructions before getting started.")
                    .font(Font.custom("Roboto-Regular", size: 17))
                    .foregroundColor(Color("Almost Black"))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
                
                HStack {
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(Color("Almost Black"))
                            .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                        
                        Button(action: {
                            show = false
                            halp = true
                        }, label: {
                            Text("START")
                                .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                        })
                            .buttonStyle(StartButton(tapAction: {
                                show = false
                                halp = true
                                circles = true
                            }
                            ))
                            .font(Font.custom(fontButtons, size: 19))
                    }
                }
            }   .padding(20)
                .frame(maxWidth: 310)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.top, 100)
        }.ignoresSafeArea()
    }
}
