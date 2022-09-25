//
//  Optimizer.swift
//  STEPN Sidekick
//
//  Shoe optimizer. Uses community data to determine best points allocation for GST earning
//  and mystery box chance.
//
//  Created by Rob Godfrey
//
//  Last updated 21 Sep 22
//

import SwiftUI

struct Optimizer: View {
    // numbers matter to calc points available
    private let common: Int = 2
    private let uncommon: Int = 3
    private let rare: Int = 4
    private let epic: Int = 5
    
    @Binding var hideTab: Bool
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    @State private var shoeRarity: Int = 2
    @State private var shoeType: Int = 0
    
    @State private var shoeName: String = ""
    @State private var energy: String = ""
    @State private var shoeLevel: Double = 1

    @State private var baseEffString: String = ""
    @State private var baseLuckString: String = ""
    @State private var baseComfString: String = ""
    @State private var baseResString: String = ""
    @State private var addedEff: Int = 0
    @State private var addedLuck: Int = 0
    @State private var addedComf: Int = 0
    @State private var addedRes: Int = 0
    @State private var gemEff: Double = 0
    @State private var gemLuck: Double = 0
    @State private var gemComf: Double = 0
    @State private var gemRes: Double = 0

    
    @State private var popCircles: Bool = false
    @State private var popShoe: Bool = false
    @State private var energySelected: Bool = false

    var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color("Light Green"))
                    .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
                                
                ScrollView {
                    VStack {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color("Almost Black"))
                                .offset(x: 5, y: 5)
                                .padding(.top, 4)
                                .padding(.horizontal, 18)
                                .frame(maxWidth: 500)

                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(.white)
                                .onTapGesture(perform: {
                                    clearFocus()
                                })
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("Almost Black"), lineWidth: 2)
                                    )
                                .padding(.horizontal, 18)
                                .padding(.top, 4)
                                .frame(maxWidth: 500)
                                                 
                            VStack(spacing: 0){
                            
                                // MARK: Shoe + gems
                                ZStack{
                                    Circle()
                                        .foregroundColor(Color(hex: outerCircleColor))
                                        .frame(height: 190)
                                        .scaleEffect(popCircles ? 1.1 : 1)
                                    
                                    Circle()
                                        .foregroundColor(Color(hex: middleCircleColor))
                                        .frame(width: 150)
                                        .scaleEffect(popCircles ? 1.1 : 1)

                                    Circle()
                                        .foregroundColor(Color(hex: innerCircleColor))
                                        .frame(width: 110)
                                        .scaleEffect(popCircles ? 1.1 : 1)

                                    Image(shoeImageResource)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 180)
                                        .scaleEffect(popShoe ? 1.1 : 1)
                                    
                                }.padding(.vertical, 30)
                                    .padding(.top, 15)
                                    .overlay(
                                        HStack {
                                            ZStack {
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(Color("Gem Socket Shadow"))
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)
                                                    .padding(.top, 4)
                                                    .padding(.leading, 2)
                                            
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)
                                                
                                                Image(shoeLevel >= 5 ? "gem_plus" : "gem_lock")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(.top, 2)
                                                    .padding(.bottom, 2)
                                                    .frame(height: 32)
                                                
                                            }.padding(.top, 30)
                                                .padding(.leading, 45)
                                            
                                        }, alignment: .topLeading
                                    )
                                    .overlay(
                                        HStack {
                                            ZStack {
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(Color("Gem Socket Shadow"))
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)
                                                    .padding(.top, 4)
                                                    .padding(.leading, 2)
                                                
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)

                                                Image(shoeLevel >= 10 ? "gem_plus" : "gem_lock")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(.top, 2)
                                                    .padding(.bottom, 2)
                                                    .frame(height: 32)
                                                
                                            }.padding(.top, 30)
                                                .padding(.trailing, 45)
                                            
                                        }, alignment: .topTrailing
                                    )
                                    .overlay(
                                        HStack {
                                            ZStack {
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(Color("Gem Socket Shadow"))
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)
                                                    .padding(.top, 4)
                                                    .padding(.leading, 2)
                                                
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)

                                                Image(shoeLevel >= 15 ? "gem_plus" : "gem_lock")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(.top, 2)
                                                    .padding(.bottom, 2)
                                                    .frame(height: 32)
                                                
                                            }.padding(.bottom, 12)
                                                .padding(.leading, 45)
                                            
                                        }, alignment: .bottomLeading
                                    )
                                    .overlay(
                                        HStack {
                                            ZStack {
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(Color("Gem Socket Shadow"))
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)
                                                    .padding(.top, 4)
                                                    .padding(.leading, 2)
                                                
                                                Image("gem_socket_gray_0")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 46, height: 46)

                                                Image(shoeLevel >= 20 ? "gem_plus" : "gem_lock")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(.top, 2)
                                                    .padding(.bottom, 2)
                                                    .frame(height: 32)
                                                
                                            }.padding(.bottom, 12)
                                                .padding(.trailing, 45)
                                            
                                        }, alignment: .bottomTrailing
                                    )
                                    .frame(maxWidth: 400)
                                
                                // MARK: Shoe name
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .foregroundColor(Color("Almost Black"))
                                        .frame(minWidth: 140, maxWidth: 140, minHeight: 36, maxHeight: 36)
                                        .padding(.top, 6)
                                        .padding(.leading, 4)
                                    
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .foregroundColor(Color(hex: labelHexColor))
                                        .frame(minWidth: 140, maxWidth: 140, minHeight: 36, maxHeight: 36)
                                        .overlay(RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color("Almost Black"), lineWidth: 1.4))
                                    
                                    TextField("Shoe Name", text: $shoeName, onEditingChanged: { (editingChanged) in
                                        if editingChanged {
                                            withAnimation(.easeOut .speed(1.5)) {
                                                hideTab = true
                                            }
                                        }})
                                        .disableAutocorrection(true)
                                        .onReceive(shoeName.publisher.collect()) {
                                            self.shoeName = String($0.prefix(12))
                                        }
                                        .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                        .font(Font.custom(fontTitles, size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                    
                                }.padding(.top, -10)
                                
                                // MARK: Shoe selector
                                HStack(spacing: 8) {
                                    Image("arrow_left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 18)
                                        .padding(.horizontal, 10)
                                    
                                    Text("")
                                        .font(Font.custom(fontHeaders, size: 12))
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 14)
                                    
                                    Text("1")
                                        .font(Font.custom(fontTitles, size: 17))
                                        .foregroundColor(Color("Almost Black"))
                                        .frame(width: 14)
                                    
                                    Text("2")
                                        .font(Font.custom(fontHeaders, size: 12))
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 14)
                                    
                                    Image("arrow_right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 18)
                                        .padding(.horizontal, 10)
                                }.padding(5)
                                    .padding(.bottom, 5)
                                
                                HStack(spacing: 5) {
                                    // MARK: Rarity stack
                                    VStack(spacing: 1) {
                                        Text("Rarity")
                                            .font(Font.custom(fontHeaders, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(height: 36)
                                                .padding([.top, .leading], 2)
                                                .padding([.bottom, .trailing], -3)
                                        
                                            Button(action: {
                                                // in tap action
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color(hex: labelHexColor))
                                                        .frame(height: 36)
                                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color("Almost Black"), lineWidth: 1.4))
                                                    
                                                    Text(rarityString)
                                                        .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                        .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                                }
                                            }).buttonStyle(OptimizerButtons(tapAction: {
                                                clearFocus()
                                                popCircles = true
                                                withAnimation(.linear(duration: 0.8)) {
                                                    popCircles = false
                                                }
                                                if shoeRarity == 5 {
                                                    shoeRarity = 2
                                                } else {
                                                    shoeRarity += 1
                                                }
                                            }))
                                            .font(Font.custom(fontButtons, size: 17))
                                        }
                                    }
                                    
                                    // MARK: Type stack
                                    VStack(spacing: 1) {
                                        Text("Type")
                                            .font(Font.custom(fontHeaders, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(height: 36)
                                                .padding([.top, .leading], 2)
                                                .padding([.bottom, .trailing], -3)
                                        
                                            Button(action: {
                                                // in tap action
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .foregroundColor(Color(hex: labelHexColor))
                                                        .frame(height: 36)
                                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color("Almost Black"), lineWidth: 1.4))
                                                    
                                                    HStack(spacing: 0) {
                                                        Image("footprint")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(maxWidth: shoeType == runner ? 10 : 0, maxHeight: 14)
                                                        
                                                        Image("footprint")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(maxWidth: shoeType == runner || shoeType == jogger ? 10 : 0, maxHeight: 14)
                                                    
                                                        Image(shoeType == trainer ? "trainer_t" : "footprint")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(height: 14)
                                                            .padding(.trailing, 5)
                                                        
                                                        Text(shoeTypeString)
                                                            .frame(height: 36)
                                                            .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                                        
                                                    }.frame(minWidth: 100, maxWidth: 105)
                                                }
                                            }).buttonStyle(OptimizerButtons(tapAction: {
                                                clearFocus()
                                                popShoe = true
                                                if shoeType == 3 {
                                                    shoeType = 0
                                                } else {
                                                    shoeType += 1
                                                }
                                                withAnimation(.linear(duration: 0.8)) {
                                                    popShoe = false
                                                }
                                            }))
                                            .font(Font.custom(fontButtons, size: 17))
                                        }
                                    }
                                    
                                    // MARK: Energy stack
                                    VStack(spacing: 1) {
                                        Text("100% Energy")
                                            .font(Font.custom(fontHeaders, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .foregroundColor(Color("Energy Blue Border"))
                                                .frame(height: 36)
                                                .padding([.top, .leading], 2)
                                                .padding([.bottom, .trailing], -3)
                                         
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .foregroundColor(energySelected ? Color("Energy Blue Lighter") : Color("Energy Blue"))
                                                .frame(height: 36)
                                                .overlay(RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color("Energy Blue Border"), lineWidth: 1.4))
                                            
                                            Image("energy_bolt")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.trailing, 14)
                                                .frame(minWidth: 100, maxWidth: 105, minHeight: 20, maxHeight: 20, alignment: .trailing)
                                            
                                            TextField("0.0", text: $energy, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    energySelected = true
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                } else {
                                                    energySelected = false
                                                }})
                                                .padding(.trailing, 6)
                                                .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                .font(Font.custom(fontTitles, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                                                .onReceive(energy.publisher.collect()) {
                                                    self.energy = String($0.prefix(4))
                                                    if Double(energy) ?? 0 > 25 {
                                                        energy = "25"
                                                    }
                                                }
                                        }
                                    }
                                }.padding(.horizontal, 40)
                                    .frame(maxWidth: 400)
                                
                                // MARK: Level slider
                                ZStack {
                                    CustomSlider(value: $shoeLevel)
                                        .padding(.horizontal, 40)
                                        .frame(maxWidth: 400, maxHeight: 30)
                                    
                                    HStack {
                                        Text("Level " + String(Int(shoeLevel)))
                                            .font(Font.custom(fontTitles, size: 15))
                                            .foregroundColor(Color("Almost Black"))
                                            .padding(.leading, 20)
                                            
                                        Spacer()
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                }.padding(.vertical, 10)
                                    .padding(.top, 10)
                                
                                // MARK: Titles
                                HStack(alignment: .bottom) {
                                    Text("Attributes")
                                        .font(Font.custom(fontTitles, size: 23))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Spacer()
                                    
                                    Text("Base")
                                        .font(Font.custom(fontTitles, size: 16))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.horizontal, 30)
                                                                        
                                    VStack(spacing: 20) {
                                        Text("Total")
                                            .font(Font.custom(fontTitles, size: 16))
                                            .foregroundColor(Color("Almost Black"))
                                            .padding(.horizontal, 30)
                                    }
                                }.padding(.vertical, 15)
                                    .padding(.horizontal, 40)
                                    .frame(maxWidth: 400)
                                
                                // MARK: Attributes
                                VStack {
                                    ZStack {
                                        HStack {
                                            HStack {
                                                Image("gem_symbol_efficiency")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Efficiency")
                                                    .font(Font.custom(fontTitles, size: 16))
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                            
                                            Spacer()
                                            
                                            TextField(baseRangeHint, text: $baseEffString, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                }})
                                                .font(Font.custom(fontHeaders, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .keyboardType(.decimalPad)
                                                .frame(width: 95)
                                                .onReceive(baseEffString.publisher.collect()) {
                                                    self.baseEffString = String($0.prefix(5))
                                                    if Double(baseEffString) ?? 0 < basePointsMin && baseEffString != "" {
                                                        baseEffString = String(basePointsMin)
                                                    } else if Double(baseEffString) ?? 0 > basePointsMax {
                                                        baseEffString = String(basePointsMax)
                                                    }
                                                }
                                            
                                            Text("0.0")
                                                .font(Font.custom(fontTitles, size: 23))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 90)
                                        }.padding(.horizontal, 40)
                                            .frame(maxWidth: 400)
                                        
                                        HStack(spacing: 30) {
                                            Spacer()
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("-")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("+")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                        }.padding(.horizontal, 20)
                                            .frame(maxWidth: 440)
                                    }
                                        
                                    ZStack {
                                        HStack {
                                            HStack {
                                                Image("gem_symbol_luck")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Luck")
                                                    .font(Font.custom(fontTitles, size: 16))
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                            
                                            Spacer()

                                            TextField(baseRangeHint, text: $baseLuckString, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                }})
                                                .font(Font.custom(fontHeaders, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .keyboardType(.decimalPad)
                                                .frame(width: 95)
                                                .onReceive(baseLuckString.publisher.collect()) {
                                                    self.baseLuckString = String($0.prefix(5))
                                                    if Double(baseLuckString) ?? 0 < basePointsMin && baseLuckString != "" {
                                                        baseLuckString = String(basePointsMin)
                                                    } else if Double(baseLuckString) ?? 0 > basePointsMax {
                                                        baseLuckString = String(basePointsMax)
                                                    }
                                                }
                                            
                                            Text("0.0")
                                                .font(Font.custom(fontTitles, size: 23))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 90)
                                        }.padding(.horizontal, 40)
                                            .frame(maxWidth: 400)
                                        
                                        HStack(spacing: 30) {
                                            Spacer()
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("-")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("+")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                        }.padding(.horizontal, 20)
                                            .frame(maxWidth: 440)
                                    }
                                    
                                    ZStack {
                                        HStack {
                                            HStack {
                                                Image("gem_symbol_comfort")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Comfort")
                                                    .font(Font.custom(fontTitles, size: 16))
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                            
                                            Spacer()
                                            
                                            TextField(baseRangeHint, text: $baseComfString, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                }})
                                                .font(Font.custom(fontHeaders, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .keyboardType(.decimalPad)
                                                .frame(width: 95)
                                                .onReceive(baseComfString.publisher.collect()) {
                                                    self.baseComfString = String($0.prefix(5))
                                                    if Double(baseComfString) ?? 0 < basePointsMin && baseComfString != "" {
                                                        baseComfString = String(basePointsMin)
                                                    } else if Double(baseComfString) ?? 0 > basePointsMax {
                                                        baseComfString = String(basePointsMax)
                                                    }
                                                }
                                            
                                            Text("0.0")
                                                .font(Font.custom(fontTitles, size: 23))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 90)
                                        }.padding(.horizontal, 40)
                                            .frame(maxWidth: 400)
                                        
                                        HStack(spacing: 30) {
                                            Spacer()
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("-")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("+")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                        }.padding(.horizontal, 20)
                                            .frame(maxWidth: 440)
                                    }
                                    
                                    ZStack {
                                        HStack {
                                            HStack {
                                                Image("gem_symbol_res")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Resilience")
                                                    .font(Font.custom(fontTitles, size: 16))
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                            
                                            Spacer()
                                            
                                            TextField(baseRangeHint, text: $baseResString, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                }})
                                                .font(Font.custom(fontHeaders, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .keyboardType(.decimalPad)
                                                .frame(width: 95)
                                                .onReceive(baseResString.publisher.collect()) {
                                                    self.baseResString = String($0.prefix(5))
                                                    if Double(baseResString) ?? 0 < basePointsMin && baseResString != "" {
                                                        baseResString = String(basePointsMin)
                                                    } else if Double(baseResString) ?? 0 > basePointsMax {
                                                        baseResString = String(basePointsMax)
                                                    }
                                                }
                                            
                                            Text("0.0")
                                                .font(Font.custom(fontTitles, size: 23))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 90)
                                        }.padding(.horizontal, 40)
                                            .frame(maxWidth: 400)
                                        
                                        HStack(spacing: 30) {
                                            Spacer()
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("-")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                            
                                            Button(action: {
                                                // action goes here
                                            }, label: {
                                                Text("+")
                                                    .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                    .foregroundColor(Color("Almost Black"))
                                                    .frame(width: 50, height: 40)
                                            })
                                        }.padding(.horizontal, 20)
                                            .frame(maxWidth: 440)
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Spacer()
                                        
                                        Text("Points Available: ")
                                            .font(Font.custom(fontHeaders, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                        
                                        Text(String(pointsAvailable))
                                            .font(Font.custom(fontTitles, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                            .padding(.trailing, 5)
                                        
                                    }.frame(minWidth: 295, maxWidth: 310, minHeight: 20)
                                        .padding(.bottom, 10)
                                }
                                
                                // MARK: Optimize buttons
                                HStack(spacing: 5) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(minWidth: 145, maxWidth: 150, minHeight: 40, maxHeight: 40)
                                            .padding(.top, 6)
                                            .padding(.leading, 6)
                                        
                                        Button(action: {
                                            // in tapAction
                                        }, label: {
                                            Text("OPTIMIZE GST")
                                                .frame(minWidth: 145, maxWidth: 150, minHeight: 40, maxHeight: 40)
                                        })
                                            .buttonStyle(StartButton(tapAction: {
                                                UIApplication.shared.hideKeyboard()
                                            })).font(Font.custom(fontButtons, size: 18))
                                                                     
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(minWidth: 145, maxWidth: 150, minHeight: 40, maxHeight: 40)
                                            .padding(.top, 6)
                                            .padding(.leading, 6)
                                        
                                        Button(action: {
                                            // in tapAction
                                        }, label: {
                                            Text("OPTIMIZE LUCK")
                                                .frame(minWidth: 145, maxWidth: 150, minHeight: 40, maxHeight: 40)
                                        })
                                            .buttonStyle(StartButton(tapAction: {
                                                UIApplication.shared.hideKeyboard()
                                            })).font(Font.custom(fontButtons, size: 18))
                                                                     
                                    }
                                }.frame(minWidth: 300, maxWidth: 315)
                                    .padding(.vertical, 10)
                                
                                // MARK: Calculated totals
                                VStack(spacing: 15) {
                                    HStack(spacing: 6) {
                                        Text("Est. GST / Daily Limit:")
                                            .font(Font.custom(fontHeaders, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0.0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Text("/")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Text(String(gstLimit))
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("logo_gst")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    HStack(spacing: 6) {
                                        Text("Durability Loss:")
                                            .font(Font.custom(fontHeaders, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    HStack(spacing: 6) {
                                        Text("Repair Cost:")
                                            .font(Font.custom(fontHeaders, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("logo_gst")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    HStack(spacing: 6) {
                                        Text("HP Loss:")
                                            .font(Font.custom(fontHeaders, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    HStack(spacing: 6) {
                                        Text("Restoration Cost:")
                                            .font(Font.custom(fontHeaders, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("gem_comf_level1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                        Text("+")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                            .padding(.horizontal, 5)
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("logo_gst")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    HStack(spacing: 6) {
                                        Text("Total Income:")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Spacer()
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("logo_gst")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                        Text("-")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                            .padding(.horizontal, 5)
                                        
                                        Text("0")
                                            .font(Font.custom(fontTitles, size: 18))
                                            .foregroundColor(Color("Almost Black"))
                                        
                                        Image("gem_comf_level1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("More Details")
                                            .font(Font.custom(fontHeaders, size: 16))
                                            .foregroundColor(Color("Gandalf"))
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                    
                                    // MARK: Mystery box chances
                                    Text("Mystery Box Chance")
                                        .font(Font.custom(fontTitles, size: 20))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    VStack {
                                        HStack {
                                            Image("mb1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()
                                            
                                            Image("mb2")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()

                                            Image("mb3")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)

                                            Spacer()

                                            Image("mb4")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()

                                            Image("mb5")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)

                                            
                                        }.padding(.horizontal, 40)
                                            .padding(.top, 5)
                                            .frame(maxWidth: 400)
                                        
                                        HStack {
                                            Image("mb6")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()
                                            
                                            Image("mb7")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()

                                            Image("mb8")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)

                                            Spacer()

                                            Image("mb9")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                            
                                            Spacer()

                                            Image("mb10")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)

                                        }.padding(.horizontal, 40)
                                            .frame(maxWidth: 400)
                                        
                                        Text("Reset Values")
                                            .font(Font.custom(fontTitles, size: 14))
                                            .foregroundColor(Color("Gandalf"))
                                            .padding(.top, 20)
                                            .padding(.bottom, 40)
                                    }
                                }.padding(.top, 16)
                            }
                        }
                        
                        Text("Based on unofficial STEPN community data.\nActual results may vary.")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .padding(.bottom, 60)
                    }.overlay(
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
        }.ignoresSafeArea()
        .preferredColorScheme(.light)
        .background(Color("Light Green"))
    }
    
    var innerCircleColor: String {
        switch (shoeRarity) {
        case uncommon:
            return "7bc799"
        case rare:
            return "7ac4e1"
        case epic:
            return "b98fd9"
        default:
            return "ebebeb"
        }
    }
    
    var middleCircleColor: String {
        switch (shoeRarity) {
        case uncommon:
            return "cae9d9"
        case rare:
            return "cce8f4"
        case epic:
            return "e4d4f1"
        default:
            return "f7f7f7"
        }
    }
    
    var outerCircleColor: String {
        switch (shoeRarity) {
        case uncommon:
            return "ecf7f1"
        case rare:
            return "ecf7fb"
        case epic:
            return "f5eff9"
        default:
            return "fcfcfc"
        }
    }
    
    var labelHexColor: String {
        switch (shoeRarity) {
        case uncommon:
            return "48b073"
        case rare:
            return "45acd5"
        case epic:
            return "9d62cc"
        default:
            return "e9e9e9"
        }
    }
    
    var shoeImageResource: String {
        switch (shoeType) {
        case jogger:
            return "shoe_jogger"
        case runner:
            return "shoe_runner"
        case trainer:
            return "shoe_trainer"
        default:
            return "shoe_walker"
        }
    }
    
    var rarityString: String {
        switch (shoeRarity) {
        case uncommon:
            return "Uncommon"
        case rare:
            return "Rare"
        case epic:
            return "Epic"
        default:
            return "Common"
        }
    }
    
    var shoeTypeString: String {
        switch (shoeType) {
        case jogger:
            return "Jogger"
        case runner:
            return "Runner"
        case trainer:
            return "Trainer"
        default:
            return "Walker"
        }
    }
    
    var baseRangeHint: String {
        switch (shoeRarity) {
        case uncommon:
            return "8 - 21.6"
        case rare:
            return "15 - 42"
        case epic:
            return "28 - 75.6"
        default:
            return "1 - 10"
        }
    }
    
    var basePointsMin: Double {
        switch (shoeRarity) {
        case uncommon:
            return 8
        case rare:
            return 15
        case epic:
            return 28
        default:
            return 1
        }
    }
    
    var basePointsMax: Double {
        switch (shoeRarity) {
        case uncommon:
            return 21.6
        case rare:
            return 42
        case epic:
            return 75.6
        default:
            return 10
        }
    }
    
    var gstLimit: Int {
        if shoeLevel < 10 {
            return Int(5 + (round(shoeLevel) * 10))
        } else if shoeLevel < 23 {
            return Int(60 + ((round(shoeLevel) - 10) * 10))
        } else {
            return Int(195 + ((round(shoeLevel) - 23) * 15))
        }
    }
    
    var pointsAvailable: Int {
        let points: Int = Int(round(shoeLevel) * 2 * Double(shoeRarity))
        if points - addedEff - addedLuck - addedComf - addedRes < 0 {
            addedEff = 0
            addedLuck = 0
            addedComf = 0
            addedRes = 0
            return points
        } else {
            return points - addedEff - addedLuck - addedComf - addedRes
        }
    }
    
    func clearFocus() {
        UIApplication.shared.hideKeyboard()
        withAnimation(.easeOut .speed(1.5)) {
            hideTab = false
        }
    }
}

struct Optimizer_Previews: PreviewProvider {
    static var previews: some View {
        Optimizer(hideTab: .constant(false))
    }
}

// dope-ass custom slider struct (courtesy of https://swdevnotes.com/swift/2021/how-to-customise-the-slider-in-swiftui/)
struct CustomSlider: View {
    @Binding var value: Double
    
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...30
    
    var body: some View {
        GeometryReader { gr in
            let thumbSize = gr.size.height * 0.8
            let radius = gr.size.height * 0.5
            let minValue = gr.size.width * 0.015
            let maxValue = (gr.size.width * 0.98) - thumbSize
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.value - lower) * scaleFactor + minValue
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.white)
                    .frame(width: gr.size.width, height: gr.size.height * 0.95)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Almost Black"), lineWidth: 1)
                        )
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("Button Green"))
                    .frame(width: sliderVal + 10, height: 20)
                    .padding(.leading, 5)
                    Spacer()
                }.clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    Circle()
                        .foregroundColor(Color(hex: "5FF3C0"))
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if v.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                    
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}

struct OptimizerButtons: ButtonStyle {
    @State private var isLongPressing = false
    let tapAction: (()->())
    
    func makeBody(configuration: Configuration) -> some View {

        ZStack {
            configuration.label
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
