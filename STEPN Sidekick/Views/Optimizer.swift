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
    
    @AppStorage("shoeNum") private var shoeNum: Int = 1
    
    @EnvironmentObject var shoes: OptimizerShoes
    
    @Binding var hideTab: Bool
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    @State private var shoeRarity: Int = common
    @State private var shoeType: Int = walker
    
    @State private var shoeName: String = ""
    @State private var energy: String = ""
    @State private var shoeLevel: Double = 1
    @State private var pointsAvailable: Int = 0

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
    @State private var totalEff: Double = 0
    @State private var totalLuck: Double = 0
    @State private var totalComf: Double = 0
    @State private var totalRes: Double = 0
    
    @State private var gems: [Gem] = [
        Gem(socketType: -1, socketRarity: 0, mountedGem: 0),
        Gem(socketType: -1, socketRarity: 0, mountedGem: 0),
        Gem(socketType: -1, socketRarity: 0, mountedGem: 0),
        Gem(socketType: -1, socketRarity: 0, mountedGem: 0)
    ]
    
    @State private var comfGemLvlForRestore: Int = 1
    
    @State private var gemSocketNum: Int = 0
    @State private var popCircles: Bool = false
    @State private var popShoe: Bool = false
    @State private var energySelected: Bool = false
    
    @State private var gemPopup: Bool = false   // gem dialog
    @State private var gemLockedDialog: Bool = false
    @State private var gemLevelToUnlock: Int = 0
    
    @State private var resetPageDialog: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
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
                                withAnimation(.easeOut .speed(1.5)) {
                                    hideTab = false
                                }
                            })
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("Almost Black"), lineWidth: 2)
                                )
                            .padding(.horizontal, 18)
                            .padding(.top, 4)
                            .frame(maxWidth: 500)
                                             
                        VStack(spacing: 0) {
                        
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
                                        MainGems(unlocked: shoeLevel >= 5, gem: gems[0])
                                                .padding(.top, 30)
                                                .padding(.leading, 45)
                                                .onTapGesture(perform: {
                                                    clearFocus()
                                                    if shoeLevel >= 5 {
                                                        withAnimation(.easeOut .speed(3)) {
                                                            gems[0].setBasePoints(basePoints: getBasePointsGemType(socketType: gems[0].getSocketType()))
                                                            gemSocketNum = 0
                                                            hideTab = true
                                                            gemPopup = true
                                                        }
                                                    } else {
                                                        gemLockedDialog = true
                                                        gemLevelToUnlock = 5
                                                    }
                                                })
                                    }, alignment: .topLeading)
                                .overlay(
                                    HStack {
                                        MainGems(unlocked: shoeLevel >= 10, gem: gems[1])
                                                .padding(.top, 30)
                                                .padding(.trailing, 45)
                                                .onTapGesture(perform: {
                                                    clearFocus()
                                                    if shoeLevel >= 10 {
                                                        withAnimation(.easeOut .speed(3)) {
                                                            gems[1].setBasePoints(basePoints: getBasePointsGemType(socketType: gems[1].getSocketType()))
                                                            gemSocketNum = 1
                                                            hideTab = true
                                                            gemPopup = true
                                                        }
                                                    } else {
                                                        gemLockedDialog = true
                                                        gemLevelToUnlock = 10
                                                    }
                                                })
                                    }, alignment: .topTrailing
                                )
                                .overlay(
                                    HStack {
                                        MainGems(unlocked: shoeLevel >= 15, gem: gems[2])
                                                .padding(.bottom, 12)
                                                .padding(.leading, 45)
                                                .onTapGesture(perform: {
                                                    clearFocus()
                                                    if shoeLevel >= 15 {
                                                        withAnimation(.easeOut .speed(3)) {
                                                            gems[2].setBasePoints(basePoints: getBasePointsGemType(socketType: gems[2].getSocketType()))
                                                            gemSocketNum = 2
                                                            hideTab = true
                                                            gemPopup = true
                                                        }
                                                    } else {
                                                        gemLockedDialog = true
                                                        gemLevelToUnlock = 15
                                                    }
                                                })
                                    }, alignment: .bottomLeading
                                )
                                .overlay(
                                    HStack {
                                        MainGems(unlocked: shoeLevel >= 20, gem: gems[3])
                                                .padding(.bottom, 12)
                                                .padding(.trailing, 45)
                                                .onTapGesture(perform: {
                                                    clearFocus()
                                                    if shoeLevel >= 20 {
                                                        withAnimation(.easeOut .speed(3)) {
                                                            gems[3].setBasePoints(basePoints: getBasePointsGemType(socketType: gems[3].getSocketType()))
                                                            gemSocketNum = 3
                                                            hideTab = true
                                                            gemPopup = true
                                                        }
                                                    } else {
                                                        gemLockedDialog = true
                                                        gemLevelToUnlock = 20
                                                    }
                                                })
                                    }, alignment: .bottomTrailing
                                )
                                .frame(maxWidth: 400)
                                .alert(isPresented: $gemLockedDialog) {
                                    Alert(title: Text("Socket Locked"),
                                          message: Text("Available at level " + String(gemLevelToUnlock)),
                                          dismissButton: .default(Text("Okay")))
                                }
                            
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
                                            updatePoints()
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
                                CustomSlider(value: $shoeLevel, sliderAction: {
                                    updatePoints()
                                })
                                    .padding(.horizontal, 40)
                                    .frame(maxWidth: 400, maxHeight: 30)
                                
                                HStack {
                                    Text("Level " + String(Int(round(shoeLevel))))
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
                                            } else {
                                                if Double(baseEffString) ?? 0 < basePointsMin && baseEffString != "" {
                                                    baseEffString = String(basePointsMin)
                                                } else if Double(baseEffString) ?? 0 > basePointsMax {
                                                    baseEffString = String(basePointsMax)
                                                }
                                                updatePoints()
                                            }})
                                            .font(Font.custom(fontHeaders, size: 20))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                            .onReceive(baseEffString.publisher.collect()) {
                                                self.baseEffString = String($0.prefix(5))
                                            }
                                        
                                        Text(String(totalEff))
                                            .font(Font.custom(fontTitles, size: 23))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                .foregroundColor(Color(addedEff > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(addedEff > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if addedEff > 0 {
                                                        addedEff -= 1
                                                        pointsAvailable += 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    pointsAvailable += addedEff
                                                    addedEff = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
                                        })
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                .foregroundColor(Color(pointsAvailable > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(pointsAvailable > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if pointsAvailable > 0 {
                                                        addedEff += 1
                                                        pointsAvailable -= 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    addedEff += pointsAvailable
                                                    pointsAvailable = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
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
                                            } else {
                                                if Double(baseLuckString) ?? 0 < basePointsMin && baseLuckString != "" {
                                                    baseLuckString = String(basePointsMin)
                                                } else if Double(baseLuckString) ?? 0 > basePointsMax {
                                                    baseLuckString = String(basePointsMax)
                                                }
                                                updatePoints()
                                            }})
                                            .font(Font.custom(fontHeaders, size: 20))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                            .onReceive(baseLuckString.publisher.collect()) {
                                                self.baseLuckString = String($0.prefix(5))
                                            }
                                        
                                        Text(String(totalLuck))
                                            .font(Font.custom(fontTitles, size: 23))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                .foregroundColor(Color(addedLuck > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(addedLuck > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if addedLuck > 0 {
                                                        addedLuck -= 1
                                                        pointsAvailable += 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    pointsAvailable += addedLuck
                                                    addedLuck = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
                                        })
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                .foregroundColor(Color(pointsAvailable > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(pointsAvailable > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if pointsAvailable > 0 {
                                                        addedLuck += 1
                                                        pointsAvailable -= 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    addedLuck += pointsAvailable
                                                    pointsAvailable = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
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
                                            } else {
                                                if Double(baseComfString) ?? 0 < basePointsMin && baseComfString != "" {
                                                    baseComfString = String(basePointsMin)
                                                } else if Double(baseComfString) ?? 0 > basePointsMax {
                                                    baseComfString = String(basePointsMax)
                                                }
                                                updatePoints()
                                            }})
                                            .font(Font.custom(fontHeaders, size: 20))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                            .onReceive(baseComfString.publisher.collect()) {
                                                self.baseComfString = String($0.prefix(5))
                                            }
                                        
                                        Text(String(totalComf))
                                            .font(Font.custom(fontTitles, size: 23))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                .foregroundColor(Color(addedComf > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(addedComf > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if addedComf > 0 {
                                                        addedComf -= 1
                                                        pointsAvailable += 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    pointsAvailable += addedComf
                                                    addedComf = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
                                        })
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                .foregroundColor(Color(pointsAvailable > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(pointsAvailable > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if pointsAvailable > 0 {
                                                        addedComf += 1
                                                        pointsAvailable -= 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    addedComf += pointsAvailable
                                                    pointsAvailable = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
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
                                            } else {
                                                if Double(baseResString) ?? 0 < basePointsMin && baseResString != "" {
                                                    baseResString = String(basePointsMin)
                                                } else if Double(baseResString) ?? 0 > basePointsMax {
                                                    baseResString = String(basePointsMax)
                                                }
                                                updatePoints()
                                            }})
                                            .font(Font.custom(fontHeaders, size: 20))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                            .onReceive(baseResString.publisher.collect()) {
                                                self.baseResString = String($0.prefix(5))
                                            }
                                        
                                        Text(String(totalRes))
                                            .font(Font.custom(fontTitles, size: 23))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 32))
                                                .foregroundColor(Color(addedRes > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(addedRes > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if addedRes > 0 {
                                                        addedRes -= 1
                                                        pointsAvailable += 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    pointsAvailable += addedRes
                                                    addedRes = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
                                        })
                                        
                                        Button(action: {
                                            // in tapGestures
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 26))
                                                .foregroundColor(Color(pointsAvailable > 0 ? "Almost Black" : "Gem Socket Shadow"))
                                                .frame(width: 50, height: 40)
                                                .disabled(pointsAvailable > 0 ? false : true)
                                                .onTapGesture(perform: {
                                                    if pointsAvailable > 0 {
                                                        addedRes += 1
                                                        pointsAvailable -= 1
                                                        updatePoints()
                                                    }
                                                    clearFocus()
                                                })
                                                .onLongPressGesture(perform: {
                                                    addedRes += pointsAvailable
                                                    pointsAvailable = 0
                                                    updatePoints()
                                                    clearFocus()
                                                })
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
                                            // TODO: energy checks
                                            UIApplication.shared.hideKeyboard()
                                            optimizeForGst()
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
                                            optimizeForLuck()
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
                                    
                                    Text(String(gstEarned))
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color(gstEarned > Double(gstLimit) ? "Gps Red" : "Almost Black"))
                                    
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
                                    
                                    Text(String(durabilityLost))
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                }.padding(.horizontal, 40)
                                    .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                
                                HStack(spacing: 6) {
                                    Text("Repair Cost:")
                                        .font(Font.custom(fontHeaders, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Spacer()
                                    
                                    Text(String(Double(repairCostGst)))
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
                                    
                                    Text(hpLoss == 0 ? "0" : String(hpLoss))
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                }.padding(.horizontal, 40)
                                    .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                
                                HStack(spacing: 6) {
                                    Text("Restoration Cost:")
                                        .font(Font.custom(fontHeaders, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Spacer()
                                    
                                    Text(hpLoss == 0 ? "0" : String(comfGemMultiplier))
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.trailing, -2)
                                    
                                    Button(action: {
                                        if comfGemLvlForRestore == 3 {
                                            comfGemLvlForRestore = 1
                                        } else {
                                            comfGemLvlForRestore += 1
                                        }
                                    }, label: {
                                        Image(comfGemForRestoreResource)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.top, comfGemLvlForRestore == 1 ? 3 : 0)
                                            .padding(.bottom, comfGemLvlForRestore == 1 ? 2 : 0)
                                            .frame(width: 24, height: 24)
                                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                            .padding(.horizontal, -10)
                                    })
                                    
                                    Text("+")
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.horizontal, 5)
                                    
                                    Text(hpLoss == 0 ? "0" : String(restoreHpCostGst))
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
                                    
                                    Text(String(gstProfitBeforeGem))
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
                                    
                                    Text(hpLoss == 0 ? "0" : String(comfGemMultiplier))
                                        .font(Font.custom(fontTitles, size: 18))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.trailing, -2)
                                    
                                    Image(comfGemForRestoreResource)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.top, comfGemLvlForRestore == 1 ? 3 : 0)
                                        .padding(.bottom, comfGemLvlForRestore == 1 ? 2 : 0)
                                        .frame(width: 24, height: 24)
                                    
                                }.padding(.horizontal, 40)
                                    .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
                                
                                /* TODO: add this :)
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
                                 */
                                
                                VStack {
                                    HStack {
                                        Image("mb1")
                                            .resizable()
                                            .renderingMode(mb1Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb1Chance > 1 ? 1 : 0.5)
                                        
                                        Spacer()
                                        
                                        Image("mb2")
                                            .resizable()
                                            .renderingMode(mb2Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb2Chance > 1 ? 1 : 0.5)
                                        
                                        Spacer()

                                        Image("mb3")
                                            .resizable()
                                            .renderingMode(mb3Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb3Chance > 1 ? 1 : 0.5)

                                        Spacer()

                                        Image("mb4")
                                            .resizable()
                                            .renderingMode(mb4Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb4Chance > 1 ? 1 : 0.5)
                                        
                                        Spacer()

                                        Image("mb5")
                                            .resizable()
                                            .renderingMode(mb5Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb5Chance > 1 ? 1 : 0.5)

                                        
                                    }.padding(.horizontal, 40)
                                        .padding(.top, 5)
                                        .frame(maxWidth: 400)
                                    
                                    HStack {
                                        Image("mb6")
                                            .resizable()
                                            .renderingMode(mb6Chance == 0 || mb9Chance == 2 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb6Chance > 1 && mb8Chance < 2 ? 1 : 0.5)
                                        
                                        Spacer()
                                        
                                        Image("mb7")
                                            .resizable()
                                            .renderingMode(mb7Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb7Chance > 1 && mb9Chance < 2 ? 1 : 0.5)
                                        
                                        Spacer()

                                        Image("mb8")
                                            .resizable()
                                            .renderingMode(mb8Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb8Chance > 1 ? 1 : 0.5)

                                        Spacer()

                                        Image("mb9")
                                            .resizable()
                                            .renderingMode(mb9Chance == 0 ? .template : .none)
                                            .foregroundColor(Color("Gandalf"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 54, height: 54)
                                            .opacity(mb9Chance > 1 ? 1 : 0.5)
                                        
                                        Spacer()
                                        
                                        ZStack {
                                            Image("mb10")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(Color("Gandalf"))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 54, height: 54)
                                                .opacity(0.5)
                                            Text("¯\\ (ツ)_/¯".replacingOccurrences(of: " ", with: "_"))
                                                .font(Font.custom("Roboto-Regular", size: 10))
                                                .foregroundColor(Color("Almost Black"))
                                                .opacity(mb9Chance > 1 ? 1 : 0)
                                        }

                                    }.padding(.horizontal, 40)
                                        .frame(maxWidth: 400)
                                    
                                    Button(action: {
                                        withAnimation(.easeOut .speed(1.5)) {
                                            hideTab = true
                                        }
                                        resetPageDialog = true
                                    }, label: {
                                        Text("Reset Values")
                                            .font(Font.custom(fontTitles, size: 14))
                                            .foregroundColor(Color("Gandalf"))
                                            .padding(.top, 20)
                                            .padding(.bottom, 40)
                                    }).alert(isPresented: $resetPageDialog) {
                                        Alert(title: Text("Reset All Values"),
                                              message: Text("Are you sure you want to reset all values?"),
                                              primaryButton: .destructive(Text("Yes")) {
                                                resetPage()
                                            },
                                              secondaryButton: .cancel()
                                        )
                                    }
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
            }.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 1)
            
            Rectangle()
                .foregroundColor(Color("Light Green"))
                .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
        
            if gemPopup {
                GeometryReader { _ in
                    GemDialog(
                        show: $gemPopup,
                        gem: $gems[gemSocketNum],
                        shoeRarity: shoeRarity,
                        baseEff: Double(baseEffString) ?? 0,
                        baseLuck: Double(baseLuckString) ?? 0,
                        baseComf: Double(baseComfString) ?? 0,
                        baseRes: Double(baseResString) ?? 0,
                        gemEff: $gemEff,
                        gemLuck: $gemLuck,
                        gemComf: $gemComf,
                        gemRes: $gemRes
                    )
                }.onDisappear{
                    updatePoints()
                }
            }
        }.ignoresSafeArea()
            .preferredColorScheme(.light)
            .background(Color("Light Green"))
            .onAppear {
                shoeRarity = shoes.getShoe(0).shoeRarity
                shoeType = shoes.getShoe(0).shoeType
                shoeName = shoes.getShoe(0).shoeName
                energy = shoes.getShoe(0).energy
                shoeLevel = shoes.getShoe(0).shoeLevel
                pointsAvailable = shoes.getShoe(0).pointsAvailable
                baseEffString = shoes.getShoe(0).baseEffString
                baseLuckString = shoes.getShoe(0).baseLuckString
                baseComfString = shoes.getShoe(0).baseComfString
                baseResString = shoes.getShoe(0).baseResString
                addedEff = shoes.getShoe(0).addedEff
                addedLuck = shoes.getShoe(0).addedLuck
                addedComf = shoes.getShoe(0).addedComf
                addedRes = shoes.getShoe(0).addedRes
                gemEff = shoes.getShoe(0).gemEff
                gemLuck = shoes.getShoe(0).gemLuck
                gemComf = shoes.getShoe(0).gemComf
                gemRes = shoes.getShoe(0).gemRes
                gems = shoes.getShoe(0).gems
                
                updatePoints()
            }
            .onDisappear {
                let currentShoe: OptimizerShoe = OptimizerShoe(
                    shoeRarity: shoeRarity,
                    shoeType: shoeType,
                    shoeName: shoeName,
                    energy: energy,
                    shoeLevel: shoeLevel,
                    pointsAvailable: pointsAvailable,
                    baseEffString: baseEffString,
                    baseLuckString: baseLuckString,
                    baseComfString: baseComfString,
                    baseResString: baseResString,
                    addedEff: addedEff,
                    addedLuck: addedLuck,
                    addedComf: addedComf,
                    addedRes: addedRes,
                    gemEff: gemEff,
                    gemLuck: gemLuck,
                    gemComf: gemComf,
                    gemRes: gemRes,
                    gems: gems)
                
                shoes.update(shoe: currentShoe, i: 1)
            }
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
    
    // MARK: Earning calcs
    var gstEarned: Double {
        return floor((Double(energy) ?? 0) * pow(totalEff, energyCo) * 10) / 10
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
    
    var durabilityLost: Int {
        if (Double(energy) ?? 0) == 0 || totalRes == 0 {
            return 0
        }
        
        var durLoss: Int = Int(round((Double(energy) ?? 0) * (2.944 * exp(-totalRes / 6.763) + 2.119 * exp(-totalRes / 36.817) + 0.294)))
        
        if durLoss < 1 {
            durLoss = 1
        }
        return durLoss
    }
    
    var repairCostGst: Double {
        return round(baseRepairCost * Double(durabilityLost) * 10) / 10
    }
        
    var baseRepairCost: Double {
        if shoeRarity == common {
            switch (round(shoeLevel)) {
            case 1:
                return 0.31
            case 2:
                return 0.32
            case 3:
                return 0.33
            case 4:
                return 0.35
            case 5:
                return 0.36
            case 6:
                return 0.37
            case 7:
                return 0.38
            case 8:
                return 0.4
            case 9:
                return 0.41
            case 10:
                return 0.42
            case 11:
                return 0.44
            case 12:
                return 0.46
            case 13:
                return 0.48
            case 14:
                return 0.5
            case 15:
                return 0.52
            case 16:
                return 0.54
            case 17:
                return 0.56
            case 18:
                return 0.58
            case 19:
                return 0.6
            case 20:
                return 0.62
            case 21:
                return 0.64
            case 22:
                return 0.67
            case 23:
                return 0.7
            case 24:
                return 0.72
            case 25:
                return 0.75
            case 26:
                return 0.78
            case 27:
                return 0.81
            case 28:
                return 0.83
            case 29:
                return 0.87
            case 30:
                return 0.9
            default:
                return 0
            }
        } else if shoeRarity == uncommon {
            switch (round(shoeLevel)) {
            case 1:
                return 0.41
            case 2:
                return 0.43
            case 3:
                return 0.45
            case 4:
                return 0.46
            case 5:
                return 0.48
            case 6:
                return 0.5
            case 7:
                return 0.51
            case 8:
                return 0.53
            case 9:
                return 0.55
            case 10:
                return 0.57
            case 11:
                return 0.6
            case 12:
                return 0.62
            case 13:
                return 0.64
            case 14:
                return 0.66
            case 15:
                return 0.69
            case 16:
                return 0.71
            case 17:
                return 0.74
            case 18:
                return 0.77
            case 19:
                return 0.8
            case 20:
                return 0.83
            case 21:
                return 0.86
            case 22:
                return 0.89
            case 23:
                return 0.92
            case 24:
                return 0.95
            case 25:
                return 1
            case 26:
                return 1.03
            case 27:
                return 1.06
            case 28:
                return 1.11
            case 29:
                return 1.15
            case 30:
                return 1.2
            default:
                return 0
            }
        } else if shoeRarity == rare {
            switch (round(shoeLevel)) {
            case 1:
                return 0.51
            case 2:
                return 0.54
            case 3:
                return 0.57
            case 4:
                return 0.59
            case 5:
                return 0.61
            case 6:
                return 0.63
            case 7:
                return 0.65
            case 8:
                return 0.67
            case 9:
                return 0.69
            case 10:
                return 0.72
            case 11:
                return 0.75
            case 12:
                return 0.78
            case 13:
                return 0.81
            case 14:
                return 0.84
            case 15:
                return 0.87
            case 16:
                return 0.90
            case 17:
                return 0.94
            case 18:
                return 0.97
            case 19:
                return 1
            case 20:
                return 1.04
            case 21:
                return 1.08
            case 22:
                return 1.12
            case 23:
                return 1.16
            case 24:
                return 1.2
            case 25:
                return 1.25
            case 26:
                return 1.3
            case 27:
                return 1.34
            case 28:
                return 1.39
            case 29:
                return 1.45
            case 30:
                return 1.5
            default:
                return 0
            }
        } else if shoeRarity == epic {
            switch (round(shoeLevel)) {
            case 1:
                return 0.61
            case 2:
                return 0.65
            case 3:
                return 0.69
            case 4:
                return 0.72
            case 5:
                return 0.75
            case 6:
                return 0.78
            case 7:
                return 0.81
            case 8:
                return 0.84
            case 9:
                return 0.87
            case 10:
                return 0.91
            case 11:
                return 0.95
            case 12:
                return 0.99
            case 13:
                return 1.03
            case 14:
                return 1.07
            case 15:
                return 1.11
            case 16:
                return 1.15
            case 17:
                return 1.19
            case 18:
                return 1.24
            case 19:
                return 1.28
            case 20:
                return 1.33
            case 21:
                return 1.38
            case 22:
                return 1.43
            case 23:
                return 1.48
            case 24:
                return 1.51
            case 25:
                return 1.55
            case 26:
                return 1.59
            case 27:
                return 1.63
            case 28:
                return 1.66
            case 29:
                return 1.69
            case 30:
                return 1.72
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
    var gstCostBasedOnGem: Int {
        switch (comfGemLvlForRestore) {
        case 2:
            return 30
        case 3:
            return 100
        default:
            return 10
        }
    }
    
    var hpLoss: Double {
        if totalComf == 0 || (Double(energy) ?? 0) == 0 {
            return 0
        }
        
        switch (shoeRarity) {
        case common:
            return round((Double(energy) ?? 0) * 0.386 * pow(totalComf, -0.421) * 100) / 100
        case uncommon:
            return round((Double(energy) ?? 0) * 0.424 * pow(totalComf, -0.456) * 100) / 100
        case rare:
            return round((Double(energy) ?? 0) * 0.47 * pow(totalComf, -0.467) * 100) / 100
        case epic:
            return round((Double(energy) ?? 0) * 0.47 * pow(totalComf, -0.467) * 100) / 100
        default:
            return 0
        }
    }
    
    var hpPercentRestored: Double {
        if totalComf == 0 || (Double(energy) ?? 0) == 0 {
            return 1
        }
        
        switch (shoeRarity) {
        case common:
            switch (comfGemLvlForRestore) {
            case 2:
                return 39
            case 3:
                return 100
            default:
                return 3
            }
        case uncommon:
            switch (comfGemLvlForRestore) {
            case 2:
                return 23
            case 3:
                return 100
            default:
                return 1.8
            }
        case rare:
            switch (comfGemLvlForRestore) {
            case 2:
                return 16
            case 3:
                return 92
            default:
                return 1.2
            }
        case epic:
            switch (comfGemLvlForRestore) {
            case 2:
                return 11
            case 3:
                return 67
            default:
                return 0.88
            }
        default:
            return 1
        }
    }
    
    var comfGemForRestoreResource: String {
        switch (comfGemLvlForRestore) {
        case 2:
            return "gem_comf_level2"
        case 3:
            return "gem_comf_level3"
        default:
            return "gem_comf_level1"
        }
    }
    
    var restoreHpCostGst: Double {
        return round(Double(gstCostBasedOnGem) * (hpLoss / hpPercentRestored) * 10) / 10
    }
    
    var gstProfitBeforeGem: Double {
        return round((gstEarned - repairCostGst - restoreHpCostGst) * 10) / 10
    }
    
    var comfGemMultiplier: Double {
        return round(hpLoss / hpPercentRestored * 100) / 100
    }
    
    // MARK: Mystery box calcs
    // 0 = very low/no chance, 1 = low chance, 2 = high chance
    var mb1Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy <= -0.04 * totalLuck + 6 && localEnergy >= -0.05263 * totalLuck + 2 && localEnergy >= 1 && totalLuck > 1 {
            return 2
        }
        if localEnergy > -0.04 * totalLuck + 6 && localEnergy < -0.02 * totalLuck + 8 && totalLuck < 110 && totalLuck > 1 {
            return 1
        }
        return 0
    }
    
    var mb2Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy <= -0.06897 * totalLuck + 10 && localEnergy >= -1.3333 * totalLuck + 6 && localEnergy >= 2 && totalLuck > 2 {
            return 2
        }
        if localEnergy > -0.068966 * totalLuck + 10 && localEnergy < -0.04 * totalLuck + 13 && totalLuck > 2 {
            return 1
        }
        return 0
    }
    
    var mb3Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy <= -0.09091 * totalLuck + 16 && localEnergy >= 70 * pow((totalLuck + 8), -1) + 2 && localEnergy >= 3.1 && totalLuck > 3 {
            return 2
        }
        if (localEnergy > -0.09091 * totalLuck + 16 && localEnergy < -0.08333 * totalLuck + 22)
            || (localEnergy > 3.5 && localEnergy < 12 && totalLuck > 100 && totalLuck < 500) {
            return 1
        }
        return 0
    }
    
    var mb4Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy <= -0.00001 * pow((totalLuck + 150), 2) + 22 && localEnergy >= 70 * pow((totalLuck + 5), -1) + 3 && totalLuck > 4 {
            if localEnergy <= -0.0001 * pow((totalLuck + 40), 2) + 18 && localEnergy >= 50 * pow((totalLuck + 30), -0.2) - 13.5 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    var mb5Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy <= -0.00001 * pow((totalLuck + 150), 2) + 26.05 && localEnergy >= 50 * pow((totalLuck - 2), -1) + 7 && totalLuck > 5 {
            if localEnergy <= -0.00003 * pow((totalLuck + 50), 2) + 22.5 && localEnergy >= 70 * pow((totalLuck - 10), -0.1) - 32 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    var mb6Chance: Int {
        let localEnergy = Double(energy) ?? 0

        if localEnergy >= 140 * pow((totalLuck - 20), -0.5) + 1 && totalLuck > 6 {
            if localEnergy >= 70 * pow((totalLuck - 70), -0.1) - 25.5 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    var mb7Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy >= -totalLuck / 45 + 26.9 && localEnergy > 7 {
            if localEnergy >= -totalLuck / 100 + 26.5 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    var mb8Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy >= -totalLuck / 150 + 32 && localEnergy > 14 {
            return 2
        }
        return 0
    }
    
    var mb9Chance: Int {
        let localEnergy = Double(energy) ?? 0
        
        if localEnergy >= -totalLuck / 300 + 29 && localEnergy > 19 {
            return 2
        }
        return 0
    }
    
    var energyCo: Double {
        switch (shoeType) {
        case jogger:
            return 0.48
        case runner:
            return 0.49
        case trainer:
            return 0.492
        default:
            return 0.47
        }
    }
    
    func getBasePointsGemType(socketType: Int) -> Double {
        switch (socketType) {
        case luck:
            return Double(baseLuckString) ?? 0
        case comf:
            return Double(baseComfString) ?? 0
        case res:
            return Double(baseResString) ?? 0
        default:
            return Double(baseEffString) ?? 0
        }
    }
        
    func updatePoints() {
        let points: Int = Int(round(shoeLevel) * 2 * Double(shoeRarity))
       
        var gemsUnlocked: Int = 0;
        
        gemEff = 0;
        gemLuck = 0;
        gemComf = 0;
        gemRes = 0;
        
        if shoeLevel >= 20 {
            gemsUnlocked = 4
        } else if shoeLevel >= 15 {
            gemsUnlocked = 3
        } else if shoeLevel >= 10 {
            gemsUnlocked = 2
        } else if (shoeLevel >= 5) {
            gemsUnlocked = 1
        }

        if gemsUnlocked > 0 {
            for socket in 1...gemsUnlocked {
                switch (gems[socket - 1].getSocketType()) {
                case eff:
                    gems[socket - 1].setBasePoints(basePoints: Double(baseEffString) ?? 0)
                    gemEff += gems[socket - 1].getTotalPoints()
                case luck:
                    gems[socket - 1].setBasePoints(basePoints: Double(baseLuckString) ?? 0)
                    gemLuck += gems[socket - 1].getTotalPoints()
                case comf:
                    gems[socket - 1].setBasePoints(basePoints: Double(baseComfString) ?? 0)
                    gemComf += gems[socket - 1].getTotalPoints()
                case res:
                    gems[socket - 1].setBasePoints(basePoints: Double(baseResString) ?? 0)
                    gemRes += gems[socket - 1].getTotalPoints()
                default:
                    break
                }
            }
        }
        
        if points - addedEff - addedLuck - addedComf - addedRes < 0 {
            addedEff = 0
            addedLuck = 0
            addedComf = 0
            addedRes = 0
            pointsAvailable = points
        } else {
            pointsAvailable = points - addedEff - addedLuck - addedComf - addedRes
            totalEff = round(((Double(baseEffString) ?? 0) + Double(addedEff) + gemEff) * 10) / 10
            totalLuck = round(((Double(baseLuckString) ?? 0) + Double(addedLuck) + gemLuck) * 10) / 10
            totalComf = round(((Double(baseComfString) ?? 0) + Double(addedComf) + gemComf) * 10) / 10
            totalRes = round(((Double(baseResString) ?? 0) + Double(addedRes) + gemRes) * 10) / 10
        }
    }
    
    func optimizeForGst() {
        let localEnergy: Double = Double(energy) ?? 0
        let localPoints: Int = Int(round(shoeLevel) * 2 * Double(shoeRarity))
        let localEff: Double = (Double(baseEffString) ?? 0) + gemEff
        let localComf: Double = (Double(baseComfString) ?? 0) + gemComf
        let localRes: Double = (Double(baseResString) ?? 0) + gemRes
        
        var localAddedEff: Int = 0
        var localAddedComf: Int = 0
        var localAddedRes: Int = 0
        
        var optimalAddedEff: Int = 0
        var optimalAddedComf: Int = 0
        var optimalAddedRes: Int = 0
        
        var gstProfit: Double = 0
        var maxProfit: Double = 0
        
        gstProfit = round((gstEarned - repairCostGst - restoreHpCostGst) * 10) / 10
                            
        // O(n^2) w/ max 45,150 calcs... yikes :)
        while localAddedEff <= localPoints {
            while localAddedComf <= localPoints - localAddedEff {
                localAddedRes = localPoints - localAddedComf - localAddedEff

                gstProfit = round(((floor(localEnergy * pow((localEff + Double(localAddedEff)), energyCo) * 10) / 10)
                                  - (round(baseRepairCost * round(localEnergy * (2.944 * exp(-(Double(localAddedRes) + localRes) / 6.763) + 2.119 * exp(-(Double(localAddedRes) + localRes) / 36.817) + 0.294)) * 10) / 10)
                                  - (round(Double(gstCostBasedOnGem) * (hpLossForOptimizer(totalComf: (localComf + Double(localAddedComf))) / hpPercentRestored) * 10) / 10)) * 10) / 10

                if (gstProfit > maxProfit) {
                    optimalAddedEff = localAddedEff
                    optimalAddedComf = localAddedComf
                    optimalAddedRes = localAddedRes
                    maxProfit = gstProfit
                }
                localAddedComf += 1
            }
            localAddedComf = 0
            localAddedEff += 1
        }
        addedEff = optimalAddedEff
        addedLuck = 0
        addedComf = optimalAddedComf
        addedRes = optimalAddedRes
        
        updatePoints()
    }
    
    func hpLossForOptimizer(totalComf: Double) -> Double {
        switch (shoeRarity) {
        case common:
            return round((Double(energy) ?? 0) * 0.386 * pow(totalComf, -0.421) * 100) / 100
        case uncommon:
            return round((Double(energy) ?? 0) * 0.424 * pow(totalComf, -0.456) * 100) / 100
        case rare:
            return round((Double(energy) ?? 0) * 0.47 * pow(totalComf, -0.467) * 100) / 100
        case epic:
            return round((Double(energy) ?? 0) * 0.47 * pow(totalComf, -0.467) * 100) / 100
        default:
            return 0
        }
    }
    
    // optimizes for most luck with no GST loss
    func optimizeForLuck() {
        let localPoints: Int = Int(round(shoeLevel) * 2 * Double(shoeRarity))

        var localAddedEff: Int = 0
        var localAddedComf: Int = 0
        var localAddedRes: Int = 0
        var pointsSpent: Int = 0

        // favors eff, but is efficient (see what i did there)
        while !breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) && pointsSpent < localPoints {
            pointsSpent += 1
            localAddedEff = pointsSpent
            localAddedComf = 0
            localAddedRes = 0

            if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                break
            }

            while localAddedEff > 0 {
                localAddedEff -= 1
                localAddedComf += 1

                if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                    break
                }

                while localAddedComf > 0 {
                    localAddedComf -= 1
                    localAddedRes += 1

                    if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                        break
                    }
                }

                if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                    break
                }

                localAddedComf += localAddedRes
                localAddedRes = 0
            }
        }

        addedEff = localAddedEff
        addedRes = localAddedRes
        addedLuck = localPoints - pointsSpent
        addedComf = localAddedComf
        
        updatePoints()
    }
    
    // check GST profit, returns true if greater than 0
    func breakEvenGst(localAddedEff: Int, localAddedComf: Int, localAddedRes: Int) -> Bool {
        let localEnergy: Double = Double(energy) ?? 0
        let localEff: Double = (Double(baseEffString) ?? 0) + gemEff
        let localComf: Double = (Double(baseComfString) ?? 0) + gemComf
        let localRes: Double = (Double(baseResString) ?? 0) + gemRes
        
        var gstProfit: Double = 0

        gstProfit = round(((floor(localEnergy * pow((localEff + Double(localAddedEff)), energyCo) * 10) / 10)
                          - (round(baseRepairCost * round(localEnergy * (2.944 * exp(-(Double(localAddedRes) + localRes) / 6.763) + 2.119 * exp(-(Double(localAddedRes) + localRes) / 36.817) + 0.294)) * 10) / 10)
                          - (round(Double(gstCostBasedOnGem) * (hpLossForOptimizer(totalComf: (localComf + Double(localAddedComf))) / hpPercentRestored) * 10) / 10)) * 10) / 10
  
        return gstProfit >= 0
    }
    
    func resetPage() {
        shoeType = walker
        shoeRarity = common
        shoeLevel = 1
        energy = "0"
        baseEffString = "0"
        addedEff = 0
        baseLuckString = "0"
        addedLuck = 0
        baseComfString = "0"
        addedComf = 0
        baseResString = "0"
        addedRes = 0
        shoeName = ""
        gemEff = 0
        gemLuck = 0
        gemComf = 0
        gemRes = 0

        gems.removeAll()

        gems.append(Gem(socketType: -1, socketRarity: 0, mountedGem: 0))
        gems.append(Gem(socketType: -1, socketRarity: 0, mountedGem: 0))
        gems.append(Gem(socketType: -1, socketRarity: 0, mountedGem: 0))
        gems.append(Gem(socketType: -1, socketRarity: 0, mountedGem: 0))
        
        updatePoints()
    }
    
    func clearFocus() {
        UIApplication.shared.hideKeyboard()
    }
}

// dope-ass custom slider struct (courtesy of https://swdevnotes.com/swift/2021/how-to-customise-the-slider-in-swiftui/)
struct CustomSlider: View {
    @Binding var value: Double
    let sliderAction: (()->())
    
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
                                    sliderAction()
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}

// main gem stacks
struct MainGems: View {
    private var unlocked: Bool
    private var gem: Gem
    
    init(unlocked: Bool, gem: Gem) {
        self.unlocked = unlocked
        self.gem = gem
    }
    
    var body: some View {
        ZStack {
            Image("gem_socket_gray_0")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color("Gem Socket Shadow"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 46, height: 46)
                .padding(.top, 4)
                .padding(.leading, 2)
        
            Image(unlocked ? gem.getSocketImageSource() : "gem_socket_gray_0")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 46, height: 46)
            
            Image(unlocked ? gem.getGemImageSource() : "gem_lock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, CGFloat(gem.getTopPadding()))
                .padding(.bottom, CGFloat(gem.getBottomPadding()))
                .frame(height: 32)
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

struct Optimizer_Previews: PreviewProvider {
    static var previews: some View {
        Optimizer(hideTab: .constant(false))
            .environmentObject(OptimizerShoes())
    }
}
