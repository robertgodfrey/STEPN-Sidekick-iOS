//
//  ContentView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/6/22.
//

import SwiftUI

// for speed voice alerts
private let speedAlertsDisabled: Int = 0
private let speedAlertsCurrent: Int = 1
private let speedAlertsAverage: Int = 2
private let speedAlertsBoth: Int = 3

struct ActivitySettings: View {
    
    @State var startSpeedTracker: Bool = false
    
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
    
    @State private var minSpeedString = "1.0"
    @State private var maxSpeedString = "6.0"
    @State private var energyString = "0.0"
    
    @State private var shoes: [Shoe] = []
                
    var body: some View {
                
        VStack {
            if startSpeedTracker {
                SpeedTracker()

            } else {
                //NavigationView {
                    ZStack(alignment: .top) {
                        Color("Background Almost White")
                                    
                        ScrollView {
                            VStack(spacing: 0){
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .foregroundColor(Color("Light Green"))
                                        .frame(minWidth: 380, maxWidth: 420, minHeight: 30, maxHeight: 50)
                                    
                                    ZStack {
                                        Image("main_box")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(12)
                                            .frame(minWidth: 380, maxWidth: 420, minHeight: 240, idealHeight: 260, maxHeight: 260)
                                            .background(Color("Light Green"))
                                            .cornerRadius(/*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .overlay(
                                                HStack(spacing: 2) {
                                                    Image("footprint")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(minWidth: 10, idealWidth: 16, maxWidth: 16, minHeight: 10, idealHeight: 16, maxHeight: 16)
                                                        .padding(.bottom, 26)
                                                    
                                                    Text("Walker   ")
                                                        .font(Font.custom(fontButtons, size: 16))
                                                        .foregroundColor(Color("Almost Black"))
                                                        .padding(.bottom, 26)
                                            
                                            }, alignment: .bottom)
                                            .overlay(
                                                ZStack {
                                                    Circle()
                                                        .fill(Color("Almost Black"))
                                                        .frame(width: 46, height: 36)
                                                        .padding(.top, 22)
                                                        .padding(.trailing, 18)
                                                        .padding([.leading, .bottom], 10)

                                                    
                                                    Button(action: {
                                                        print("help me")

                                                    }) {
                                                        Circle()
                                                            .strokeBorder(Color("Almost Black"), lineWidth: 1)
                                                            .background(Circle().fill(Color("Help Button Orange")))
                                                            .frame(width: 46, height: 36)
                                                            .padding([.top, .trailing], 20)
                                                            .padding([.leading, .bottom], 10)
                                                    }
                                                    
                                                    Text("?")
                                                        .font(Font.custom(fontTitles, size: 16))
                                                        .foregroundColor(Color("Almost Black"))
                                                        .padding(.top, 20)
                                                        .padding(.trailing, 20)
                                                        .padding([.leading, .bottom], 10)

                                                    
                                                }, alignment: .topTrailing)
                                        
                                        Image("shoe_walker")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(minWidth: 140, idealWidth: 168, maxWidth: 168, minHeight: 140, idealHeight: 168, maxHeight: 168)
                                            .padding(.trailing, 4)
                                            .padding(.bottom, 28)
                                        
                                        HStack(spacing: 200) {
                                            Button(action: {
                                                print("left button")
                                            }) {
                                                
                                            }.frame(width: 80, height: 100)
                                            
                                            Button(action: {
                                                print("right button")
                                            }) {
                                                
                                            }.frame(width: 80, height: 100)
                                        }
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
                                        
                                        HStack(spacing: 6) {
                                            VStack(spacing: 0){
                                                Text("Minimum Speed")
                                                    .font(Font.custom(fontHeaders, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                                
                                                ZStack {

                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 48, maxHeight: 48)
                                                        .padding([.top, .leading], 5)
                                                    
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color("Button Disabled"))
                                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 48, maxHeight: 48)
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
                                                }
                                                
                                            }
                                            
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
                                                        .foregroundColor(Color("Button Disabled"))
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

                                                }
                                                
                                            }
                                        }
                                        
                                        HStack(spacing: 9) {
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
                                            .frame(minWidth: 154, maxWidth: 161, minHeight: 100, maxHeight: 160, alignment: .top)
                                                                
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
                                                        .foregroundColor(Color("Energy Blue"))
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
                                                
                                                    TextField("0.0", text: $energyString)
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
                                                
                                                Text("(0 mins 30 sec)")
                                                    .font(Font.custom(fontButtons, size: 16))
                                                    .foregroundColor(Color("Gandalf"))
                                            }.frame(minWidth: 150, maxWidth: 161, minHeight: 100, maxHeight: 160, alignment: .top)

                                        }
                                        
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
                                                    }) {
                                                        Text(voiceAlertsTime == true ? "ENABLED" : "DISABLED")
                                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)

                                                    }
                                                    .buttonStyle(MainButtons(enabled: voiceAlertsTime,
                                                            tapAction: {
                                                                voiceAlertsTime = !voiceAlertsTime
                                                                print("Time alerts button switched")
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
                                                    }) {
                                                        Text(voiceAlertsMinThirty == true ? "ENABLED" : "DISABLED")
                                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    }
                                                        .buttonStyle(MainButtons(enabled: voiceAlertsMinThirty,
                                                            tapAction: {
                                                                voiceAlertsMinThirty = !voiceAlertsMinThirty
                                                                print("1 min / 30 sec button switched")
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
                                                self.startSpeedTracker = true
                                            } ) {
                                                Text("START")
                                                    .frame(width: 165, height: 50)

                                            }
                                                .buttonStyle(StartButton(tapAction: {
                                                    self.startSpeedTracker = true
                                                }))
                                                .font(Font.custom(fontButtons, size: 25))
                                            
                                        }.padding(.vertical, 38)
                                    }
                                }
                            }
                        }
                        
                    }.ignoresSafeArea()
             //   }
            }
        }
        .onAppear() {
            initShoes()
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
    
    func initShoes() {
        shoes.append(Shoe(title: "Walker", imageSource: 0, numFeet: 1, minSpeed: 1.0, maxSpeed: 6.0))
        shoes.append(Shoe(title: "Jogger", imageSource: 1, numFeet: 2, minSpeed: 4.0, maxSpeed: 10.0))
        shoes.append(Shoe(title: "Runner", imageSource: 2, numFeet: 3, minSpeed: 8.0, maxSpeed: 20.0))
        shoes.append(Shoe(title: "Trainer", imageSource: 3, numFeet: 4, minSpeed: 1.0, maxSpeed: 20.0))
        shoes.append(Shoe(title: "Custom", imageSource: 4, numFeet: 0, minSpeed: customMinSpeed, maxSpeed: customMaxSpeed))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySettings()
    }
}
