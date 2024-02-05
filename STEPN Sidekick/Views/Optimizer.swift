//
//  Optimizer.swift
//  STEPN Sidekick
//
//  Shoe optimizer. Uses community data to determine best points allocation for GST/GMT earning
//  and mystery box chance.
//
//  Created by Rob Godfrey
//
//  Last updated 4 Feb 24
//

import SwiftUI
import Kingfisher

struct Optimizer: View {
    
    @AppStorage("shoeNum") private var shoeNum: Int = 1
    @AppStorage("comfGemLvl") private var comfGemLvlForRestore: Int = 1
    @AppStorage("gmtNumA") private var gmtNumA: Double = 0.0696
    @AppStorage("gmtNumB") private var gmtNumB: Double = 0.4821
    @AppStorage("gmtNumC") private var gmtNumC: Double = 0.25
    
    @EnvironmentObject var shoes: OptimizerShoes
    @EnvironmentObject var imageUrls: ShoeImages
    
    @Binding var hideTab: Bool
    @Binding var showAds: Bool
    
    @State var coinPrices: Coins = Coins(
        greenSatoshiToken: Coin(usd: 0),
        solana: Coin(usd: 0),
        ethereum: Coin(usd: 0),
        binancecoin: Coin(usd: 0),
        greenSatoshiTokenOnEth: Coin(usd: 0),
        greenSatoshiTokenBsc: Coin(usd: 0),
        stepn: Coin(usd: 0))
    
    @State var gemPrices: [Double] = [0,0,0]
    @State var mbChances: [Int] = [0,0,0,0,0,0,0,0,0,0]
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    @State private var shoeRarity: Int = common
    @State private var shoeType: Int = walker
    @State private var blockchain: Int = sol
    @State private var comfGemPrice: String = ""
    @State private var imageUrl = ""
    
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
    
    @State private var gmtToggleOn: Bool = false
    
    @State private var gemSocketNum: Int = 0
    @State private var popCircles: Bool = false
    @State private var popShoe: Bool = false
    @State private var energySelected: Bool = false
    @State private var comfGemPriceSelected: Bool = false
    
    @State private var gemPopup: Bool = false   // gem dialog
    @State private var gemLockedDialog: Bool = false
    @State private var gemLevelToUnlock: Int = 0
    
    @State private var gmtLevelDialog: Bool = false
    @State private var noComfGemDialog: Bool = false
    @State private var noEnergyDialog: Bool = false
    @State private var resetPageDialog: Bool = false
    @State private var noBreakEvenDialog: Bool = false
    @State private var changeImageDialog: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            Color("Light Green")
            
            if showAds {
                Rectangle()
                    .foregroundColor(Color("Light Green"))
                    .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
                
                SwiftUIBannerAd().padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            }
        
            ScrollView {
                LazyVStack {
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
                                    .foregroundColor(Color(hex: outerCircleColor(shoeRarity: shoeRarity)))
                                    .frame(height: 190)
                                    .scaleEffect(popCircles ? 1.1 : 1)
                                
                                Circle()
                                    .foregroundColor(Color(hex: middleCircleColor(shoeRarity: shoeRarity)))
                                    .frame(width: 150)
                                    .scaleEffect(popCircles ? 1.1 : 1)

                                Circle()
                                    .foregroundColor(Color(hex: innerCircleColor(shoeRarity: shoeRarity)))
                                    .frame(width: 110)
                                    .scaleEffect(popCircles ? 1.1 : 1)
                                    .onTapGesture(perform: {
                                        withAnimation(.easeOut .speed(3)) {
                                            clearFocus()
                                            changeImageDialog = true
                                            hideTab = true
                                        }
                                    })

                                if imageUrl.isEmpty {
                                    Image(shoeImageResource(shoeType: shoeType))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 180)
                                        .scaleEffect(popShoe ? 1.1 : 1)
                                        .onTapGesture(perform: {
                                            withAnimation(.easeOut .speed(3)) {
                                                clearFocus()
                                                changeImageDialog = true
                                                hideTab = true
                                            }
                                        })
                                } else {
                                    KFImage(URL(string: imageUrl)!)
                                        .fade(duration: 0.25)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 180)
                                        .scaleEffect(popShoe ? 1.1 : 1)
                                        .onTapGesture(perform: {
                                            withAnimation(.easeOut .speed(3)) {
                                                clearFocus()
                                                changeImageDialog = true
                                                hideTab = true
                                            }
                                        })
                                }
                                        
                                
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
                                        
                                        Spacer()
                                        
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
                                    }.frame(width: 390), alignment: .top)
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
                                        
                                        Spacer()
                                        
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
                                    }.frame(width: 390), alignment: .bottom
                                )
                                .frame(maxWidth: 400)
                                .alert(isPresented: $gemLockedDialog) {
                                    Alert(title: Text("Socket Locked"),
                                          message: Text("Available at level " + String(gemLevelToUnlock)),
                                          dismissButton: .default(Text("Okay")))
                                }
                            
                            VStack {
                            
                                // MARK: Shoe name
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .foregroundColor(Color("Almost Black"))
                                        .frame(minWidth: 140, maxWidth: 140, minHeight: 36, maxHeight: 36)
                                        .padding(.top, 6)
                                        .padding(.leading, 4)
                                    
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .foregroundColor(Color(hex: labelHexColor(shoeRarity: shoeRarity)))
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
                                        .font(Font.custom(fontTitles, size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(shoeRarity == common ? "Almost Black" : "White"))
                                    
                                }.padding(.top, -10)
                                
                                // MARK: Shoe selector
                                HStack(spacing: 8) {
                                    Button(action: {
                                        saveEmLoadEm(shoeToLoad: shoeNum == 1 ? 6 : shoeNum - 1)
                                        popShoe = true
                                        if shoeNum == 1 {
                                            shoeNum = 6
                                        } else {
                                            shoeNum -= 1
                                        }
                                        withAnimation(.linear(duration: 0.8)) {
                                            popShoe = false
                                        }
                                    }, label: {
                                        Image("arrow_left")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 18)
                                            .padding(15)
                                    })
                                    
                                    Text(shoeNum == 1 ? "" : String(shoeNum - 1))
                                        .font(Font.custom(fontHeaders, size: 12))
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 14)
                                    
                                    Text(String(shoeNum))
                                        .font(Font.custom(fontTitles, size: 17))
                                        .foregroundColor(Color("Almost Black"))
                                        .frame(width: 14)
                                    
                                    Text(shoeNum == 6 ? "" : String(shoeNum + 1))
                                        .font(Font.custom(fontHeaders, size: 12))
                                        .foregroundColor(Color("Gandalf"))
                                        .frame(width: 14)
                                    
                                    Button(action: {
                                        saveEmLoadEm(shoeToLoad: shoeNum == 6 ? 1 : shoeNum + 1)
                                        popShoe = true
                                        if shoeNum == 6 {
                                            shoeNum = 1
                                        } else {
                                            shoeNum += 1
                                        }
                                        withAnimation(.linear(duration: 0.8)) {
                                            popShoe = false
                                        }
                                    }, label: {
                                        Image("arrow_right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 18)
                                            .padding(15)
                                    })
                                }.padding(.vertical, -5)
                            }
                            
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
                                                    .foregroundColor(Color(hex: labelHexColor(shoeRarity: shoeRarity)))
                                                    .frame(height: 36)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("Almost Black"), lineWidth: 1.4))
                                                
                                                Text(rarityString(shoeRarity: shoeRarity))
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
                                                    .foregroundColor(Color(hex: labelHexColor(shoeRarity: shoeRarity)))
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
                                                    
                                                    Text(shoeTypeString(shoeType: shoeType))
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
                                    Text("Energy")
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
                                                if energy.doubleValue > 25 {
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
                                    Text("Level " + String(Int(floor(shoeLevel))))
                                        .font(Font.custom(fontTitles, size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.leading, 20)
                                        
                                    Spacer()
                                }.padding(.horizontal, 40)
                                    .padding(.top, 25)
                                    .frame(maxWidth: 400)
                                
                            }.padding(.bottom, 10)
                            
                            // MARK: Attributes
                            VStack {
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
                                        
                                        TextField(baseRangeHint(shoeRarity: shoeRarity), text: $baseEffString, onEditingChanged: { (editingChanged) in
                                            if editingChanged {
                                                withAnimation(.easeOut .speed(1.5)) {
                                                    hideTab = true
                                                }
                                            } else {
                                                if baseEffString.doubleValue < basePointsMin(shoeRarity: shoeRarity) && baseEffString != "" {
                                                    baseEffString = String(basePointsMin(shoeRarity: shoeRarity))
                                                } else if baseEffString.doubleValue > basePointsMax(shoeRarity: shoeRarity) {
                                                    baseEffString = String(basePointsMax(shoeRarity: shoeRarity))
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
                                        .frame(maxWidth: 400)
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

                                        TextField(baseRangeHint(shoeRarity: shoeRarity), text: $baseLuckString, onEditingChanged: { (editingChanged) in
                                            if editingChanged {
                                                withAnimation(.easeOut .speed(1.5)) {
                                                    hideTab = true
                                                }
                                            } else {
                                                if baseLuckString.doubleValue < basePointsMin(shoeRarity: shoeRarity) && baseLuckString != "" {
                                                    baseLuckString = String(basePointsMin(shoeRarity: shoeRarity))
                                                } else if baseLuckString.doubleValue > basePointsMax(shoeRarity: shoeRarity) {
                                                    baseLuckString = String(basePointsMax(shoeRarity: shoeRarity))
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
                                        .frame(maxWidth: 400)
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
                                        
                                        TextField(baseRangeHint(shoeRarity: shoeRarity), text: $baseComfString, onEditingChanged: { (editingChanged) in
                                            if editingChanged {
                                                withAnimation(.easeOut .speed(1.5)) {
                                                    hideTab = true
                                                }
                                            } else {
                                                if baseComfString.doubleValue < basePointsMin(shoeRarity: shoeRarity) && baseComfString != "" {
                                                    baseComfString = String(basePointsMin(shoeRarity: shoeRarity))
                                                } else if baseComfString.doubleValue > basePointsMax(shoeRarity: shoeRarity) {
                                                    baseComfString = String(basePointsMax(shoeRarity: shoeRarity))
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
                                        .frame(maxWidth: 400)
                                }.alert(isPresented: $noComfGemDialog) {
                                    Alert(title: Text("No Gem Price Entered"),
                                          message: Text("For a more accurate estimation, enter comfort gem price."),
                                          dismissButton: .default(Text("Okay")))
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
                                        
                                        TextField(baseRangeHint(shoeRarity: shoeRarity), text: $baseResString, onEditingChanged: { (editingChanged) in
                                            if editingChanged {
                                                withAnimation(.easeOut .speed(1.5)) {
                                                    hideTab = true
                                                }
                                            } else {
                                                if baseResString.doubleValue < basePointsMin(shoeRarity: shoeRarity) && baseResString != "" {
                                                    baseResString = String(basePointsMin(shoeRarity: shoeRarity))
                                                } else if baseResString.doubleValue > basePointsMax(shoeRarity: shoeRarity) {
                                                    baseResString = String(basePointsMax(shoeRarity: shoeRarity))
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
                                        .frame(maxWidth: 400)
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
                                        Text(gmtToggleOn ? "OPTIMIZE GMT" : "OPTIMIZE GST")
                                            .frame(minWidth: 145, maxWidth: 150, minHeight: 40, maxHeight: 40)
                                    })
                                        .buttonStyle(StartButton(tapAction: {
                                            UIApplication.shared.hideKeyboard()
                                            if energy.doubleValue != 0 {
                                                if comfGemPrice.doubleValue <= 0 {
                                                    noComfGemDialog = true
                                                }
                                                if gmtToggleOn {
                                                    optimizeForGmt()
                                                } else {
                                                    optimizeForGst(usdOn: comfGemPrice.doubleValue <= 0 ? false : true)
                                                }
                                            } else {
                                                noEnergyDialog = true
                                            }
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
                                            if energy.doubleValue != 0 {
                                                if comfGemPrice.doubleValue <= 0 {
                                                    noComfGemDialog = true
                                                }
                                                if (gmtToggleOn) {
                                                    if !optimizeForLuckGmt() {
                                                        noBreakEvenDialog = true
                                                    }
                                                } else {
                                                    if !optimizeForLuckGst() {
                                                        noBreakEvenDialog = true
                                                    }
                                                }
                                            } else {
                                                noEnergyDialog = true
                                            }
                                        })).font(Font.custom(fontButtons, size: 18))
                                                                 
                                }
                            }.frame(minWidth: 300, maxWidth: 315)
                                .padding(.vertical, 10)
                                .alert(isPresented: $noEnergyDialog) {
                                    Alert(title: Text("Enter Energy"),
                                          message: Text("Energy must be greater than 0 to optimize sneaker"),
                                          dismissButton: .default(Text("Okay")))
                                }
                            
                            // MARK: results
                            CalcedTotals(
                                gmtToggleOn: gmtToggleOn,
                                gstEarned: gstEarned(totalEff: totalEff, energyCo: energyCo, energy: energy),
                                gstLimit: gstLimit,
                                gmtLowRange: gmtLowRange,
                                gmtHighRange: gmtHighRange,
                                repairCostGst: repairCostGst,
                                restoreHpCostGst: restoreHpCostGst,
                                hpLoss: getHpLoss(comf: totalComf, energy: energy.doubleValue, shoeRarity: shoeRarity),
                                durabilityLoss: getDurabilityLost(energy: energy.doubleValue, res: totalRes),
                                comfGemMultiplier: getHpLoss(comf: totalComf, energy: energy.doubleValue, shoeRarity: shoeRarity) / hpPercentRestored,
                                comfGemLvlForRestore: $comfGemLvlForRestore,
                                comfGemForRestoreResource: comfGemForRestoreResource,
                                gmtEarned: gmtEarned,
                                gstProfitBeforeGem: gstProfitBeforeGem,
                                comfGemPrice: $comfGemPrice,
                                blockchain: blockchain,
                                coinPrices: coinPrices,
                                gemPrices: gemPrices
                            ).padding(.top, 10)
                                .padding(.bottom, 20)
                                .alert(isPresented: $noBreakEvenDialog) {
                                    Alert(title: Text("Unable to Optimize Luck"),
                                          message: Text("No possible point allocation where shoe does not lose money."),
                                          dismissButton: .default(Text("Okay")))
                                }

                            // MARK: bottom three stacks
                            HStack(spacing: 5) {
                                // MARK: Chain stack
                                VStack(spacing: 1) {
                                    Text("Chain")
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
                                                    .fill(LinearGradient(
                                                            gradient: Gradient(
                                                                colors: [Color(hex: blockchain == sol ? "b04ced"
                                                                               : labelChainHexColor(blockchain: blockchain)), Color(hex: labelChainHexColor(blockchain: blockchain))]),
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                                                    .frame(height: 36)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("Almost Black"), lineWidth: 1.4))
                                                
                                                Text(chainString(blockchain: blockchain))
                                                    .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    .foregroundColor(Color("White"))
                                            }
                                        }).buttonStyle(OptimizerButtons(tapAction: {
                                            clearFocus()
                                            if blockchain == 2 {
                                                blockchain = 0
                                            } else {
                                                blockchain += 1
                                            }
                                            gemApiCall()
                                        }))
                                        .font(Font.custom(fontButtons, size: 17))
                                    }
                                }
                                
                                // MARK: GST/GMT stack
                                LazyVStack(spacing: 1) {
                                    Text("Token")
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
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(
                                                                colors: [gmtToggleOn ? Color(hex: "c6a242") : Color(hex: "D1D1D1"),
                                                                         gmtToggleOn ? Color(hex: "F4E5AE") : Color(hex: "E1E1E1")]),
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                                                    .frame(height: 36)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("Almost Black"), lineWidth: 1.4))
                                                
                                                HStack(spacing: 5) {
                                                    Text(gmtToggleOn ? "GMT" : "GST")
                                                        .frame(height: 36)
                                                        .foregroundColor(Color("Almost Black"))
                                                        .padding(.leading, 5)
                                                    Image(gmtToggleOn ? "logo_gmt" : "logo_gst")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(height: 20)
                                                }.frame(minWidth: 100, maxWidth: 105)
                                            }
                                        }).buttonStyle(OptimizerButtons(tapAction: {
                                            clearFocus()
                                            if shoeLevel >= 30 {
                                                self.gmtToggleOn.toggle()
                                            } else {
                                                gmtLevelDialog = true
                                            }
                                        }))
                                        .font(Font.custom(fontButtons, size: 17))
                                    }
                                }
                                
                                // MARK: Comfort gem price stack
                                VStack(spacing: 1) {
                                    Text("Gem Price")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(height: 36)
                                            .padding([.top, .leading], 2)
                                            .padding([.bottom, .trailing], -3)
                                     
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(comfGemPriceSelected ? Color(hex: "EC6262") : Color(hex: "EC3F3F"))
                                            .frame(height: 36)
                                            .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color("Almost Black"), lineWidth: 1.4))
                                        
                                        HStack(spacing: 4) {
                                            TextField("0.0", text: $comfGemPrice, onEditingChanged: { (editingChanged) in
                                                if editingChanged {
                                                    comfGemPriceSelected = true
                                                    withAnimation(.easeOut .speed(1.5)) {
                                                        hideTab = true
                                                    }
                                                } else {
                                                    comfGemPriceSelected = false
                                                }})
                                                .font(Font.custom(fontTitles, size: 20))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color("White"))
                                                .keyboardType(.decimalPad)
                                                .onReceive(comfGemPrice.publisher.collect()) {
                                                    self.comfGemPrice = String($0.prefix(6))
                                                }
                                                .frame(width: getGemInputWidth(length: comfGemPrice.count))
                                                .padding(.leading, 10)
                                            
                                            Image("logo_gmt_solid")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                }
                            }.padding(.horizontal, 40)
                                .frame(maxWidth: 400)
                                .alert(isPresented: $gmtLevelDialog) {
                                    Alert(title: Text("Check Level"),
                                          message: Text("Sneaker must be level 30 to activate GMT earning"),
                                          dismissButton: .default(Text("Okay")))
                                }
                    
                            // MARK: Mystery box chances
                            VStack(spacing: 0) {
                                MysteryBoxChances(mbChances: mbChances)
                                    
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
                                
                            }.padding(.top, 26)
                           
                        }
                    }
                    
                    Text("Based on unofficial community data.\nActual results may vary.")
                        .font(Font.custom("Roboto-Regular", size: 13))
                        .foregroundColor(Color("Gandalf"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 4) {
                        Text("Price data provided by")
                            .font(Font.custom("Roboto-Regular", size: 13))
                            .foregroundColor(Color("Gandalf"))
                            .multilineTextAlignment(.center)

                        Image("coin_gecko")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .padding(.top, 2)
                        
                    }.padding(.bottom, 60)
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
            }.padding(.top, (showAds ? (UIDevice.current.userInterfaceIdiom == .pad ? 90 : 50) : 0) + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
            if gemPopup {
                GeometryReader { _ in
                    GemDialog(
                        show: $gemPopup,
                        gem: $gems[gemSocketNum],
                        shoeRarity: shoeRarity,
                        baseEff: baseEffString.doubleValue,
                        baseLuck: baseLuckString.doubleValue,
                        baseComf: baseComfString.doubleValue,
                        baseRes: baseResString.doubleValue,
                        gemEff: $gemEff,
                        gemLuck: $gemLuck,
                        gemComf: $gemComf,
                        gemRes: $gemRes,
                        dismissAction: { updatePoints() }
                    )
                }
            }
            if changeImageDialog {
                GeometryReader { _ in
                    AddImageDialog(
                        show: $changeImageDialog,
                        url: $imageUrl
                    )
                }.onDisappear{
                    updatePoints()
                }
            }
        }.ignoresSafeArea()
            .preferredColorScheme(.light)
            .background(Color("Light Green"))
            .onAppear {
                gmtToggleOn = shoes.getShoe(shoeNum - 1).gmtToggle
                blockchain = shoes.getShoe(shoeNum - 1).blockchain
                shoeRarity = shoes.getShoe(shoeNum - 1).shoeRarity
                shoeType = shoes.getShoe(shoeNum - 1).shoeType
                shoeName = shoes.getShoe(shoeNum - 1).shoeName
                energy = shoes.getShoe(shoeNum - 1).energy
                shoeLevel = shoes.getShoe(shoeNum - 1).shoeLevel
                pointsAvailable = shoes.getShoe(shoeNum - 1).pointsAvailable
                baseEffString = shoes.getShoe(shoeNum - 1).baseEffString
                baseLuckString = shoes.getShoe(shoeNum - 1).baseLuckString
                baseComfString = shoes.getShoe(shoeNum - 1).baseComfString
                baseResString = shoes.getShoe(shoeNum - 1).baseResString
                addedEff = shoes.getShoe(shoeNum - 1).addedEff
                addedLuck = shoes.getShoe(shoeNum - 1).addedLuck
                addedComf = shoes.getShoe(shoeNum - 1).addedComf
                addedRes = shoes.getShoe(shoeNum - 1).addedRes
                gemEff = shoes.getShoe(shoeNum - 1).gemEff
                gemLuck = shoes.getShoe(shoeNum - 1).gemLuck
                gemComf = shoes.getShoe(shoeNum - 1).gemComf
                gemRes = shoes.getShoe(shoeNum - 1).gemRes
                gems = shoes.getShoe(shoeNum - 1).gems
                imageUrl = imageUrls.getUrl(shoeNum - 1)
                
                tokenApiCall()
                gemApiCall()
                updatePoints()
            }
            .onDisappear {
                let currentShoe: OptimizerShoe = OptimizerShoe(
                    gmtToggle: gmtToggleOn,
                    blockchain: blockchain,
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
                
                shoes.update(shoe: currentShoe, i: shoeNum - 1)
                imageUrls.update(url: imageUrl, i: shoeNum - 1)
            }
            .onChange(of: energy) { _ in
                mbApiCall()
            }
            .onChange(of: totalLuck) { _ in
                mbApiCall()
            }
    }
    
    // MARK: Gmt calcs
    func gmtEarnedPerEnergy(comf: Double) -> Double {
        if !gmtToggleOn {
            return 0
        }
        var gmtBaseline: Double = gmtNumA * pow(comf, gmtNumB) - gmtNumC
        
        switch (shoeType) {
        case walker:
            gmtBaseline = gmtBaseline * 0.98
        case runner:
            gmtBaseline = gmtBaseline * 1.02
        case trainer:
            gmtBaseline = gmtBaseline * 1.025
        default:
            gmtBaseline = gmtBaseline * 1
        }
        
        if gmtBaseline < 0 {
            return 0
        }
        
        return gmtBaseline
    }
    
    var gmtEarned: Double {
        return round(gmtEarnedPerEnergy(comf:totalComf) * energy.doubleValue * 10) / 10
    }
    
    var gmtLowRange: Double {
        var gmtLow: Double = 0
        gmtLow = round((gmtEarnedPerEnergy(comf:totalComf) - 0.2) * 20) / 100
        
        if gmtLow < 0 {
            return 0
        }
        return gmtLow
    }
    
    var gmtHighRange: Double {
        return round((gmtEarnedPerEnergy(comf:totalComf) + 0.2) * 20) / 100
    }
    
    var gstLimit: Int {
        if shoeLevel < 10 {
            return Int(5 + (floor(shoeLevel) * 10))
        } else if shoeLevel < 23 {
            return Int(60 + ((floor(shoeLevel) - 10) * 10))
        } else {
            return Int(195 + ((floor(shoeLevel) - 23) * 15))
        }
    }
      
    func getDurabilityLost(energy: Double, res: Double) -> Int {
        if energy == 0 || res == 0 {
            return 0
        }
        var durLoss: Int
        if res > 160 {
            durLoss = Int(round(energy * (-0.0005 * res + 0.4)))
        } else {
            durLoss = Int(round(energy * (2.944 * exp(-res / 6.763) + 2.119 * exp(-res / 36.817) + 0.294)))
        }
        return max(durLoss, 1)
    }
      
    var repairCostGst: Double {
        return round(baseRepairCost * Double(getDurabilityLost(energy: energy.doubleValue, res: totalRes)) * 10) / 10
    }
          
    var baseRepairCost: Double {
        if shoeRarity == common {
            switch (floor(shoeLevel)) {
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
            switch (floor(shoeLevel)) {
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
            switch (floor(shoeLevel)) {
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
            switch (floor(shoeLevel)) {
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
    
    var hpPercentRestored: Double {
        if totalComf == 0 || energy.doubleValue == 0 {
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
        return round(Double(gstCostBasedOnGem) * (getHpLoss(comf: totalComf, energy: energy.doubleValue, shoeRarity: shoeRarity) / hpPercentRestored) * 10) / 10
    }
    
    var gstProfitBeforeGem: Double {
        if gmtToggleOn {
            return round((repairCostGst + restoreHpCostGst) * 10) / 10
        }
        return gstEarned(totalEff: totalEff, energyCo: energyCo, energy: energy) - repairCostGst - restoreHpCostGst
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
    
    func gemApiCall() {
        let urlOne = "https://apilb.stepn.com/run/orderlist?saleId=1&order=2001&chain="
        let urlTwo = "&refresh=true&page=0&otd=&type=501&gType=3&quality=&level="
        let urlThree = "&bread=0"
        var chainCode: String
        
        switch (blockchain) {
        case bsc:
            chainCode = "104"
        case eth:
            chainCode = "101"
        default:
            chainCode = "103"
        }
        
        
        guard let urlLevelOne = URL(string: urlOne + chainCode + urlTwo + "2010" + urlThree) else {
            print("Invalid URL")
            return
        }
        let requestOne = URLRequest(url: urlLevelOne)

        URLSession.shared.dataTask(with: requestOne) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GemPrices.self, from: data)
                    DispatchQueue.main.async {
                        gemPrices[0] = Double(response.data[2].sellPrice) / 100
                        
                        if comfGemLvlForRestore == 1 {
                            comfGemPrice = String(gemPrices[0])
                        }
                    }
                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
            }
        }.resume()
        
        guard let urlLevelTwo = URL(string: urlOne + chainCode + urlTwo + "3010" + urlThree) else {
            print("Invalid URL")
            return
        }
        let requestTwo = URLRequest(url: urlLevelTwo)
        
        print(requestTwo)

        URLSession.shared.dataTask(with: requestTwo) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GemPrices.self, from: data)
                    DispatchQueue.main.async {
                        gemPrices[1] = Double(response.data[2].sellPrice) / 100
                        
                        if comfGemLvlForRestore == 2 {
                            comfGemPrice = String(gemPrices[1])
                        }
                    }
                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
            }
        }.resume()
        
        guard let urlLevelThree = URL(string: urlOne + chainCode + urlTwo + "4010" + urlThree) else {
            print("Invalid URL")
            return
        }
        let requestThree = URLRequest(url: urlLevelThree)

        URLSession.shared.dataTask(with: requestThree) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GemPrices.self, from: data)
                    DispatchQueue.main.async {
                        gemPrices[2] = Double(response.data[2].sellPrice) / 100
                        
                        if comfGemLvlForRestore == 3 {
                            comfGemPrice = String(gemPrices[2])
                        }
                    }
                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func tokenApiCall() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=stepn%2Csolana%2Cgreen-satoshi-token%2Cbinancecoin%2Cgreen-satoshi-token-bsc%2Cethereum%2Cgreen-satoshi-token-on-eth&vs_currencies=usd") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Coins.self, from: data) {
                    DispatchQueue.main.async {
                        coinPrices = response
                    }
                    return
                }
            }
        }.resume()
    }
    
    func mbApiCall() {
        guard let mbUrl = URL(string: "https://stepn-sidekick.vercel.app/mb?energy=\(energy)&luck=\(totalLuck)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: mbUrl)
        if let apiKey = Bundle.main.infoDictionary?["SidekickAPI"] as? String {
            request.setValue(apiKey, forHTTPHeaderField: "API-Key")
        } else {
            print("API key not found")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MbPredictions.self, from: data)
                    DispatchQueue.main.async {
                        mbChances = response.predictions
                    }
                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func getGemInputWidth(length: Int) -> CGFloat {
        switch (length) {
        case 4:
            return 40
        case 5:
            return 50
        case 6:
            return 60
        default:
            return 30
        }
    }
    
    func getBasePointsGemType(socketType: Int) -> Double {
        switch (socketType) {
        case luck:
            return baseLuckString.doubleValue
        case comf:
            return baseComfString.doubleValue
        case res:
            return baseResString.doubleValue
        default:
            return baseEffString.doubleValue
        }
    }
        
    func updatePoints() {
        let points: Int = Int(floor(shoeLevel) * 2 * Double(shoeRarity))
       
        var gemsUnlocked: Int = 0
        
        gemEff = 0
        gemLuck = 0
        gemComf = 0
        gemRes = 0
        
        if shoeLevel >= 20 {
            gemsUnlocked = 4
        } else if shoeLevel >= 15 {
            gemsUnlocked = 3
        } else if shoeLevel >= 10 {
            gemsUnlocked = 2
        } else if shoeLevel >= 5 {
            gemsUnlocked = 1
        }
        
        if shoeLevel < 30 {
            gmtToggleOn = false
        }

        if gemsUnlocked > 0 {
            for socket in 1...gemsUnlocked {
                switch (gems[socket - 1].getSocketType()) {
                case eff:
                    gems[socket - 1].setBasePoints(basePoints: baseEffString.doubleValue)
                    gemEff += gems[socket - 1].getTotalPoints()
                case luck:
                    gems[socket - 1].setBasePoints(basePoints: baseLuckString.doubleValue)
                    gemLuck += gems[socket - 1].getTotalPoints()
                case comf:
                    gems[socket - 1].setBasePoints(basePoints: baseComfString.doubleValue)
                    gemComf += gems[socket - 1].getTotalPoints()
                case res:
                    gems[socket - 1].setBasePoints(basePoints: baseResString.doubleValue)
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
            totalEff = round((baseEffString.doubleValue + Double(addedEff) + gemEff) * 10) / 10
            totalLuck = round((baseLuckString.doubleValue + Double(addedLuck) + gemLuck) * 10) / 10
            totalComf = round((baseComfString.doubleValue + Double(addedComf) + gemComf) * 10) / 10
            totalRes = round((baseResString.doubleValue + Double(addedRes) + gemRes) * 10) / 10
        }
    }
    
    func optimizeForGst(usdOn: Bool) {
        let localEnergy: Double = energy.doubleValue
        let localPoints: Int = Int(floor(shoeLevel) * 2 * Double(shoeRarity))
        
        let localEff: Double = baseEffString.doubleValue + gemEff
        let localComf: Double = baseComfString.doubleValue + gemComf
        let localRes: Double = baseResString.doubleValue + gemRes
        
        var localAddedEff: Int = 0
        var localAddedComf: Int = 0
        var localAddedRes: Int = 0
        
        var optimalAddedEff: Int = 0
        var optimalAddedComf: Int = 0
        var optimalAddedRes: Int = 0
        
        var profit: Double = -50
        var maxProfit: Double = -50
        
        var chainGstPrice: Double
        var localGemMultiplier: Double
        
        switch (blockchain) {
        case bsc:
            chainGstPrice = coinPrices.greenSatoshiTokenBsc.usd
        case eth:
            chainGstPrice = coinPrices.greenSatoshiTokenOnEth.usd
        default:
            chainGstPrice = coinPrices.greenSatoshiToken.usd
        }
                    
        // O(n^2) w/ max 45,150 calcs... yikes :)
        while localAddedEff <= localPoints {
            while localAddedComf <= localPoints - localAddedEff {
                localAddedRes = localPoints - localAddedComf - localAddedEff
                
                localGemMultiplier = getHpLoss(comf: localComf + Double(localAddedComf), energy: localEnergy, shoeRarity: shoeRarity) / hpPercentRestored

                profit = gstEarned(totalEff: localEff + Double(localAddedEff), energyCo: energyCo, energy: String(localEnergy))
                                - (round(baseRepairCost * Double(getDurabilityLost(energy: localEnergy, res: localRes + Double(localAddedRes))) * 10) / 10)
                                - (Double(gstCostBasedOnGem) * localGemMultiplier)
                
                if usdOn {
                    profit = (profit * chainGstPrice) - (localGemMultiplier * comfGemPrice.doubleValue * coinPrices.stepn.usd)
                }
            
                if profit > maxProfit {
                    optimalAddedEff = localAddedEff
                    optimalAddedComf = localAddedComf
                    optimalAddedRes = localAddedRes
                    maxProfit = profit
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
    
    // finds the point allocation that is most profitable for GMT
    func optimizeForGmt() {
        let localEnergy: Double = energy.doubleValue
        let localPoints: Int = Int(floor(shoeLevel) * 2 * Double(shoeRarity))
        
        let localComf: Double = baseComfString.doubleValue + gemComf
        let localRes: Double = baseResString.doubleValue + gemRes
        var localAddedComf: Int = 0
        var localAddedRes: Int = 0
        
        var optimalAddedRes: Int = 0
        var optimalAddedComf: Int = 0
        var profit: Double = -50
        var maxProfit: Double = -50
        
        var chainGstPrice: Double
        var localGemMultiplier: Double
        
        switch (blockchain) {
        case bsc:
            chainGstPrice = coinPrices.greenSatoshiTokenBsc.usd
        case eth:
            chainGstPrice = coinPrices.greenSatoshiTokenOnEth.usd
        default:
            chainGstPrice = coinPrices.greenSatoshiToken.usd
        }

        while (localAddedComf <= localPoints) {
            localAddedRes = localPoints - localAddedComf
            localGemMultiplier = getHpLoss(comf: localComf + Double(localAddedComf), energy: localEnergy, shoeRarity: shoeRarity) / hpPercentRestored

            // total profit GMT in USD
            profit = localEnergy * gmtEarnedPerEnergy(comf: localComf + Double(localAddedComf)) * coinPrices.stepn.usd
            // subtract USD cost of repair durability restore HP (GST)
            profit -= chainGstPrice * Double(getDurabilityLost(energy: localEnergy, res: localRes + Double(localAddedRes))) * baseRepairCost
            profit -= chainGstPrice * Double(gstCostBasedOnGem) * localGemMultiplier
            // subtract USD cost of restore HP
            profit -= (localGemMultiplier * comfGemPrice.doubleValue * coinPrices.stepn.usd)

            if profit > maxProfit {
                optimalAddedComf = localAddedComf
                optimalAddedRes = localAddedRes
                maxProfit = profit
            }

            localAddedComf += 1
        }

        addedRes = optimalAddedRes
        addedLuck = 0
        addedEff = 0
        addedComf = optimalAddedComf
        updatePoints()
    }
    
    // optimizes for most luck with no GST loss. returns true if able to find point allocation that results in a profit greater than or equal to 0
    // very (very) terrible runtime, but in most cases should exit fairly quickly
    func optimizeForLuckGst() -> Bool {
        let localPoints: Int = Int(floor(shoeLevel) * 2 * Double(shoeRarity))
        var localAddedEff: Int = 4
        var localAddedComf: Int = 0
        var localAddedRes: Int = 0
        var pointsSpent: Int = 4
        
        if breakEvenGst(localAddedEff: 0, localAddedComf: 0, localAddedRes: 0) {
            addedEff = 0
            addedLuck = localPoints
            addedComf = 0
            addedRes = 0
            updatePoints()
            return true
        }
        
        // check if over max value is unprofitable to avoid long calculation
        if !breakEvenGst(localAddedEff: localPoints - 20, localAddedComf: localPoints - 20, localAddedRes: 10) {
            return false
        }
        
        // check if half of expected max value is unprofitable. if it is, start there
        if !breakEvenGst(localAddedEff: Int(Double(localPoints) / 2) - 30, localAddedComf: 20, localAddedRes: 10) {
            pointsSpent = Int(Double(localPoints) / 2)
        }
        
        var breakEven: Bool = false
        
        // skip by 4 to save time - will get within a few luck points of "precise" algorithm and MUCH faster (probably best to have a little buffer room anyway)
        while pointsSpent <= localPoints {
            if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                breakEven = true
                break
            }

            while localAddedEff > 0 {
                localAddedEff -= 4
                localAddedComf += 4
            
                if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                    breakEven = true
                    break
                }

                while localAddedComf > 0 {
                    localAddedComf -= 4
                    localAddedRes += 4
                    
                    if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                        breakEven = true
                        break
                    }
                }

                if breakEven {
                    break
                }

                localAddedComf += localAddedRes
                localAddedRes = 0

            }
            
            if breakEven {
                break
            }
            
            pointsSpent += 4
            localAddedEff = pointsSpent
            localAddedComf = 0
            localAddedRes = 0
        }

        if !breakEven {
            return false
        }
        
        if breakEvenGst(localAddedEff: localAddedEff - 1, localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
            localAddedEff -= 1
            pointsSpent -= 1
        }
        if breakEvenGst(localAddedEff: localAddedEff, localAddedComf: localAddedComf - 1, localAddedRes: localAddedRes) {
            localAddedComf -= 1
            pointsSpent -= 1
        }
        if breakEvenGst(localAddedEff: localAddedEff - 1, localAddedComf: localAddedComf, localAddedRes: localAddedRes - 1) {
            localAddedRes -= 1
            pointsSpent -= 1
        }
        
        addedEff = localAddedEff
        addedRes = localAddedRes
        addedLuck = localPoints - pointsSpent
        addedComf = localAddedComf
        updatePoints()
        
        return true
    }
    
    // optimizes for most luck with no GMT loss. much better runtime than gst luck algorithm
    // returns true if able to find point allocation that results in a profit greater than or equal to 0
    func optimizeForLuckGmt() -> Bool {
        let localPoints: Int = Int(floor(shoeLevel) * 2 * Double(shoeRarity))
        var localAddedComf: Int = 4
        var localAddedRes: Int = 0
        var pointsSpent: Int = 4
        
        if breakEvenGmt(localAddedComf: 0, localAddedRes: 0) {
            addedEff = 0
            addedLuck = localPoints
            addedComf = 0
            addedRes = 0
            updatePoints()
            return true
        }
        
        // check if over max value is unprofitable to avoid long calculation
        if !breakEvenGmt(localAddedComf: localPoints - 15, localAddedRes: 20) {
            return false
        }
                 
        // check if half of expected max value is unprofitable. if it is, start there
        if !breakEvenGmt(localAddedComf: Int(Double(localPoints) / 2) - 10, localAddedRes: 10) {
            pointsSpent = Int(Double(localPoints) / 2)
        }
        
        var breakEven: Bool = false
        
        while localAddedComf <= localPoints {
            if breakEvenGmt(localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                breakEven = true
                break
            }
            
            while localAddedComf > 0 {
                localAddedComf -= 4
                localAddedRes += 4
                
                if breakEvenGmt(localAddedComf: localAddedComf, localAddedRes: localAddedRes) {
                    breakEven = true
                    break
                }
            }

            if breakEven {
                break
            }

            pointsSpent += 4
            localAddedComf = pointsSpent
            localAddedRes = 0
        }
        
        if !breakEven {
            return false
        }
        
        if breakEvenGmt(localAddedComf: localAddedComf - 1, localAddedRes: localAddedRes) {
            localAddedComf -= 1
            pointsSpent -= 1
        }
        if breakEvenGmt(localAddedComf: localAddedComf, localAddedRes: localAddedRes - 1) {
            localAddedRes -= 1
            pointsSpent -= 1
        }
        
        addedEff = 0
        addedLuck = localPoints - pointsSpent
        addedComf = localAddedComf
        addedRes = localAddedRes
        updatePoints()
        
        return true
    }
    
    // check GST profit, returns true if greater than 0
    func breakEvenGst(localAddedEff: Int, localAddedComf: Int, localAddedRes: Int) -> Bool {
        let localEnergy: Double = energy.doubleValue
        let localEff: Double = baseEffString.doubleValue + gemEff
        let localComf: Double = baseComfString.doubleValue + gemComf
        let localRes: Double = baseResString.doubleValue + gemRes
        let localGemMultiplier = getHpLoss(comf: localComf + Double(localAddedComf), energy: localEnergy, shoeRarity: shoeRarity) / hpPercentRestored
                
        var chainGstPrice: Double
        
        switch (blockchain) {
        case bsc:
            chainGstPrice = coinPrices.greenSatoshiTokenBsc.usd
        case eth:
            chainGstPrice = coinPrices.greenSatoshiTokenOnEth.usd
        default:
            chainGstPrice = coinPrices.greenSatoshiToken.usd
        }
        
        var profit = gstEarned(totalEff: localEff + Double(localAddedEff), energyCo: energyCo, energy: String(localEnergy))
                        - (round(baseRepairCost * Double(getDurabilityLost(energy: localEnergy, res: localRes + Double(localAddedRes))) * 10) / 10)
                        - (Double(gstCostBasedOnGem) * localGemMultiplier)
                
        profit = (profit * chainGstPrice) - (localGemMultiplier * comfGemPrice.doubleValue * coinPrices.stepn.usd)
            
        return profit >= 0
    }
    
    // check GMT profit, returns true if greater than 0
    func breakEvenGmt(localAddedComf: Int, localAddedRes: Int) -> Bool {
        let localEnergy: Double = energy.doubleValue
        let localComf: Double = baseComfString.doubleValue + gemComf
        let localRes: Double = baseResString.doubleValue + gemRes
        let localGemMultiplier = getHpLoss(comf: localComf + Double(localAddedComf), energy: localEnergy, shoeRarity: shoeRarity) / hpPercentRestored
        
        var chainGstPrice: Double
        
        switch (blockchain) {
        case bsc:
            chainGstPrice = coinPrices.greenSatoshiTokenBsc.usd
        case eth:
            chainGstPrice = coinPrices.greenSatoshiTokenOnEth.usd
        default:
            chainGstPrice = coinPrices.greenSatoshiToken.usd
        }
        
        // total profit GMT in USD
        var profit = localEnergy * gmtEarnedPerEnergy(comf: localComf + Double(localAddedComf)) * coinPrices.stepn.usd
        // subtract USD cost of repair durability restore HP (GST)
        profit -= chainGstPrice * Double(getDurabilityLost(energy: localEnergy, res: localRes + Double(localAddedRes))) * baseRepairCost
        profit -= chainGstPrice * Double(gstCostBasedOnGem) * localGemMultiplier
        // subtract USD cost of restore HP
        profit -= (localGemMultiplier * comfGemPrice.doubleValue * coinPrices.stepn.usd)
        
        return profit >= 0
    }

    func saveEmLoadEm(shoeToLoad: Int) {
        // save em
        let currentShoe: OptimizerShoe = OptimizerShoe(
            gmtToggle: gmtToggleOn,
            blockchain: blockchain,
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
        
        shoes.update(shoe: currentShoe, i: shoeNum - 1)
        imageUrls.update(url: imageUrl, i: shoeNum - 1)
        
        // load em
        gmtToggleOn = shoes.getShoe(shoeToLoad - 1).gmtToggle
        blockchain = shoes.getShoe(shoeToLoad - 1).blockchain
        shoeRarity = shoes.getShoe(shoeToLoad - 1).shoeRarity
        shoeType = shoes.getShoe(shoeToLoad - 1).shoeType
        shoeName = shoes.getShoe(shoeToLoad - 1).shoeName
        energy = shoes.getShoe(shoeToLoad - 1).energy
        shoeLevel = shoes.getShoe(shoeToLoad - 1).shoeLevel
        pointsAvailable = shoes.getShoe(shoeToLoad - 1).pointsAvailable
        baseEffString = shoes.getShoe(shoeToLoad - 1).baseEffString
        baseLuckString = shoes.getShoe(shoeToLoad - 1).baseLuckString
        baseComfString = shoes.getShoe(shoeToLoad - 1).baseComfString
        baseResString = shoes.getShoe(shoeToLoad - 1).baseResString
        addedEff = shoes.getShoe(shoeToLoad - 1).addedEff
        addedLuck = shoes.getShoe(shoeToLoad - 1).addedLuck
        addedComf = shoes.getShoe(shoeToLoad - 1).addedComf
        addedRes = shoes.getShoe(shoeToLoad - 1).addedRes
        gemEff = shoes.getShoe(shoeToLoad - 1).gemEff
        gemLuck = shoes.getShoe(shoeToLoad - 1).gemLuck
        gemComf = shoes.getShoe(shoeToLoad - 1).gemComf
        gemRes = shoes.getShoe(shoeToLoad - 1).gemRes
        gems = shoes.getShoe(shoeToLoad - 1).gems
        
        imageUrl = imageUrls.getUrl(shoeToLoad - 1)
        
        updatePoints()
    }
    
    func resetPage() {
        gmtToggleOn = false
        blockchain = sol
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
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: thumbSize, height: thumbSize + 30)
                            .offset(x: sliderVal)
                            .opacity(0.0001)

                        Circle()
                            .foregroundColor(Color(hex: "5FF3C0"))
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: sliderVal)
                    }
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

// for those pesky decimal comma-using countries
extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

struct Optimizer_Previews: PreviewProvider {
    static var previews: some View {
        Optimizer(hideTab: .constant(false), showAds: .constant(false))
            .environmentObject(OptimizerShoes())
            .environmentObject(ShoeImages())
    }
}
                                   
func getHpLoss(comf: Double, energy: Double, shoeRarity: Int) -> Double {
   if comf == 0 || energy == 0 {
       return 0
   }
   
   switch (shoeRarity) {
   case common:
       return round(energy * 0.386 * pow(comf, -0.421) * 100) / 100
   case uncommon:
       return round(energy * 0.424 * pow(comf, -0.456) * 100) / 100
   case rare:
       return round(energy * 0.47 * pow(comf, -0.467) * 100) / 100
   case epic:
       return round(energy * 0.47 * pow(comf, -0.467) * 100) / 100
   default:
       return 0
   }
}

func innerCircleColor(shoeRarity: Int) -> String {
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

func middleCircleColor(shoeRarity: Int) -> String {
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

func outerCircleColor(shoeRarity: Int) -> String {
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

func labelHexColor(shoeRarity: Int) -> String {
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

func labelChainHexColor(blockchain: Int) -> String {
    switch (blockchain) {
    case bsc:
        return "f3ba2c"
    case eth:
        return "8a93b2"
    default:
        return "11edaa"
    }
}

func chainString(blockchain: Int) -> String {
    switch (blockchain) {
    case bsc:
        return "BSC"
    case eth:
        return "ETH"
    default:
        return "SOL"
    }
}

func shoeImageResource(shoeType: Int) -> String {
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

func rarityString(shoeRarity: Int) -> String {
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

func shoeTypeString(shoeType: Int) -> String {
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

func baseRangeHint(shoeRarity: Int) -> String {
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

func basePointsMin(shoeRarity: Int) -> Double {
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

func basePointsMax(shoeRarity: Int) -> Double {
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

// MARK: gst earning calcs
func gstEarned(totalEff: Double, energyCo: Double, energy: String) -> Double {
    return floor(energy.doubleValue * pow(totalEff, energyCo) * 10) / 10
}

struct CalcedTotals: View {
    let gmtToggleOn: Bool
    let gstEarned: Double
    let gstLimit: Int
    let gmtLowRange: Double
    let gmtHighRange: Double
    let repairCostGst: Double
    let restoreHpCostGst: Double
    let hpLoss: Double
    let durabilityLoss: Int
    let comfGemMultiplier: Double
    @Binding var comfGemLvlForRestore: Int
    let comfGemForRestoreResource: String
    let gmtEarned: Double
    let gstProfitBeforeGem: Double
    @Binding var comfGemPrice: String
    let blockchain: Int
    let coinPrices: Coins
    let gemPrices: [Double]
    
    var body: some View {
        // MARK: Calculated totals
        LazyVStack(spacing: 15) {
            HStack(spacing: 6) {
                Text(gmtToggleOn ? "Est. GMT / Min:" : "Est. GST / Daily Limit:")
                    .font(Font.custom(fontHeaders, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Spacer()
                
                Text(gmtToggleOn ? "" : String(gstEarned))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color(gstEarned > Double(gstLimit) ? "Gps Red" : "Almost Black"))
                
                Text(gmtToggleOn ? "" : "/")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Text(gmtToggleOn ? (String(gmtLowRange) + " - " + String(gmtHighRange)) : String(gstLimit))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Image(gmtToggleOn ? "coin_gmt" : "coin_gst")
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
                
                Text(String(durabilityLoss))
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
                
                Image("coin_gst")
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
                
                Text(String(hpLoss))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
            }.padding(.horizontal, 40)
                .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
            
            HStack(spacing: 6) {
                Text("Restoration Cost:")
                    .font(Font.custom(fontHeaders, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Spacer()
                
                Text(String(round(comfGemMultiplier * 100) / 100))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.trailing, -2)
                
                Button(action: {
                    if comfGemLvlForRestore == 3 {
                        comfGemLvlForRestore = 1
                        comfGemPrice = String(gemPrices[0])
                    } else if comfGemLvlForRestore == 2 {
                        comfGemLvlForRestore += 1
                        comfGemPrice = String(gemPrices[2])
                    } else {
                        comfGemLvlForRestore += 1
                        comfGemPrice = String(gemPrices[1])
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
                
                Image("coin_gst")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
            }.padding(.horizontal, 40)
                .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
            
            HStack(spacing: 4) {
                Text("Total Income:")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Spacer()
                
                Text(String(gmtEarned))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .opacity(gmtToggleOn ? 1 : 0)
                
                Image("coin_gmt")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: gmtToggleOn ? 20 : 0, height: 20)
                
                Text("-")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .opacity(gmtToggleOn ? 1 : 0)
                
                Text(String(round(gstProfitBeforeGem * 10) / 10))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Image("coin_gst")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Text("-")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Text(String(round(comfGemMultiplier * 100) / 100))
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.trailing, -2)
                
                Image(comfGemForRestoreResource)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, comfGemLvlForRestore == 1 ? 3 : 0)
                    .padding(.bottom, comfGemLvlForRestore == 1 ? 2 : 0)
                    .frame(width: 24, height: 24)
                
            }.padding(.leading, 40)
                .padding(.trailing, 38)
                .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
            
            HStack(spacing: 4) {
                Text("Total Income USD:")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                Spacer()
                
                Text(comfGemPrice.doubleValue > 0 ? usdIncome : "Enter Gem Price ↓")
                    .font(Font.custom(comfGemPrice.doubleValue > 0 ? fontTitles : "RobotoCondensed-Italic", size: comfGemPrice.doubleValue > 0 ? 18 : 16))
                    .foregroundColor(Color(comfGemPrice.doubleValue > 0 ? "Almost Black" : "Gandalf"))
                    .padding(.trailing, 4)
                
                Text("$")
                    .font(Font.custom("RobotoCondensed-Bold", size: 18))
                    .foregroundColor(Color("Almost Black"))
            }.padding(.leading, 40)
                .padding(.trailing, 45)
                .frame(maxWidth: 400, minHeight: 20, maxHeight: 20)
        }
    }
    
    var usdIncome: String {
        var chainGstPrice: Double
        var usdProf: Double
        
        switch (blockchain) {
        case bsc:
            chainGstPrice = coinPrices.greenSatoshiTokenBsc.usd
        case eth:
            chainGstPrice = coinPrices.greenSatoshiTokenOnEth.usd
        default:
            chainGstPrice = coinPrices.greenSatoshiToken.usd
        }
        
        if gmtToggleOn {
            usdProf = gmtEarned * coinPrices.stepn.usd - (repairCostGst + restoreHpCostGst) * chainGstPrice
        } else {
            usdProf = gstProfitBeforeGem * chainGstPrice
        }
        usdProf -= comfGemMultiplier * comfGemPrice.doubleValue * coinPrices.stepn.usd
         
        return String(format: "%.2f", round(usdProf * 100) / 100)
    }
}

struct MysteryBoxChances: View {
    var mbChances: [Int]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Mystery Box Chance")
                .font(Font.custom(fontTitles, size: 20))
                .foregroundColor(Color("Almost Black"))
                .padding(.bottom, 15)
            
            HStack {
                VStack(spacing: 0) {
                    Image("mb1")
                        .resizable()
                        .renderingMode(mbChances[0] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[0] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[0])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[0] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[0] > 0 ? 1 : 0)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Image("mb2")
                        .resizable()
                        .renderingMode(mbChances[1] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[1] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[1])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[1] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[1] > 0 ? 1 : 0)
                }
                    
                Spacer()

                VStack(spacing: 0) {
                    Image("mb3")
                        .resizable()
                        .renderingMode(mbChances[2] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[2] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[2])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[2] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[2] > 0 ? 1 : 0)
                }

                Spacer()

                VStack(spacing: 0) {
                    Image("mb4")
                        .resizable()
                        .renderingMode(mbChances[3] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[3] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[3])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[3] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[3] > 0 ? 1 : 0)
                }
                
                Spacer()

                VStack(spacing: 0) {
                    Image("mb5")
                        .resizable()
                        .renderingMode(mbChances[4] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[4] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[4])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[4] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[4] > 0 ? 1 : 0)
                }

                
            }.padding(.horizontal, 40)
                .padding(.top, 5)
                .frame(maxWidth: 400)
            
            HStack {
                VStack(spacing: 0) {
                    Image("mb6")
                        .resizable()
                        .renderingMode(mbChances[5] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[5] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[5])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[5] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[5] > 0 ? 1 : 0)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Image("mb7")
                        .resizable()
                        .renderingMode(mbChances[6] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[6] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[6])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[6] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[6] > 0 ? 1 : 0)
                }
                
                Spacer()

                VStack(spacing: 0) {
                    Image("mb8")
                        .resizable()
                        .renderingMode(mbChances[7] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[7] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[7])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[7] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[7] > 0 ? 1 : 0)
                }
                
                Spacer()

                VStack(spacing: 0) {
                    Image("mb9")
                        .resizable()
                        .renderingMode(mbChances[8] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[8] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[8])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[8] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[8] > 0 ? 1 : 0)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Image("mb10")
                        .resizable()
                        .renderingMode(mbChances[9] == 0 ? .template : .none)
                        .foregroundColor(Color("Gandalf"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 54, height: 54)
                        .opacity(mbChances[9] >= 30 ? 1 : 0.5)
                    Text("\(mbChances[9])%")
                        .font(Font.custom(fontTitles, size: 16))
                        .foregroundColor(mbChances[9] >= 30 ? Color("Almost Black") : Color("Gandalf"))
                        .opacity(mbChances[9] > 0 ? 1 : 0)
                }

            }.padding(.horizontal, 40)
                .frame(maxWidth: 400)
        }
    }
}
