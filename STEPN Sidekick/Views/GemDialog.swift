//
//  GemDialog.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 9/25/22.
//

import SwiftUI

struct GemDialog: View {
    
    @Binding var show: Bool
    @Binding var gem: Gem
    var shoeRarity: Int
    
    var baseEff: Double
    var baseLuck: Double
    var baseComf: Double
    var baseRes: Double
    @Binding var gemEff: Double
    @Binding var gemLuck: Double
    @Binding var gemComf: Double
    @Binding var gemRes: Double
    
    @State private var showGemMoreDeets: Bool = false

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)   
            
            VStack {
                Text("SELECT SOCKET TYPE")
                    .font(Font.custom(fontTitles, size: 20))
                    .foregroundColor(Color("Almost Black"))
                
                HStack(spacing: 15) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 25)
                                )
                                .frame(width: 55, height: 55)
                                .opacity(gem.getSocketType() == eff ? 1 : 0)
                            
                            
                            Image("gem_symbol_efficiency")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                                .onTapGesture(perform: {
                                    gem.setSocketType(socketType: eff)
                                    gem.setBasePoints(basePoints: baseEff)
                                })
                        }
                        Text("Efficiency")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                        
                    }
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [Color(hex: "B6E4F3"), .white]),
                                    center: .center,
                                    startRadius: 15,
                                    endRadius: 25)
                                )
                                .frame(width: 55, height: 55)
                                .opacity(gem.getSocketType() == luck ? 1 : 0)
                            
                            
                            Image("gem_symbol_luck")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                                .onTapGesture(perform: {
                                    gem.setSocketType(socketType: luck)
                                    gem.setBasePoints(basePoints: baseLuck)
                                })
                        }
                        Text("Luck")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                    }
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [Color(hex: "F4A6A6"), .white]),
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 25)
                                )
                                .frame(width: 55, height: 55)
                                .opacity(gem.getSocketType() == comf ? 1 : 0)
                            
                            Image("gem_symbol_comfort")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                                .onTapGesture(perform: {
                                    gem.setSocketType(socketType: comf)
                                    gem.setBasePoints(basePoints: baseComf)

                                })
                        }
                        Text("Comfort")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                    }
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    gradient: Gradient(colors: [Color(hex: "B8C6F1"), .white]),
                                    center: .center,
                                    startRadius: 15,
                                    endRadius: 25)
                                )
                                .frame(width: 55, height: 55)
                                .opacity(gem.getSocketType() == res ? 1 : 0)
                            
                            Image("gem_symbol_res")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                                .onTapGesture(perform: {
                                    gem.setSocketType(socketType: res)
                                    gem.setBasePoints(basePoints: baseRes)

                                })
                        }
                        Text("Resilience")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                    }
                }
                
                HStack(spacing: 15) {
                    Text("-")
                        .font(Font.custom("Roboto-Black", size: 22))
                        .foregroundColor(Color(gem.getSocketRarity() > 0 ? "Almost Black" : "Gem Socket Shadow"))
                        .frame(width: 50, height: 40)
                        .onTapGesture(perform: {
                            if gem.getSocketRarity() > 0 {
                                gem.setSocketRarity(socketRarity: gem.getSocketRarity() - 1)
                            }
                        })
                    
                    ZStack {
                        Image("gem_socket_gray_0")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("Gem Socket Shadow"))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 46)
                            .offset(x: 1.5, y: 2.5)
                                            
                        Image(gem.getSocketImageSource())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 46)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() != 0 {
                                    gem.setMountedGem(mountedGem: 0)
                                }
                            })
                        
                        Image(gem.getGemImageSource())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, CGFloat(gem.getBottomPadding()))
                            .padding(.top, CGFloat(gem.getTopPadding()))
                            .frame(maxWidth: 32, maxHeight: 32)
                    }
                    
                    Text("+")
                        .font(Font.custom("Roboto-Black", size: 18))
                        .foregroundColor(Color(gem.getSocketRarity() < gemSocketMaxRarity ? "Almost Black" : "Gem Socket Shadow"))
                        .frame(width: 50, height: 40)
                        .onTapGesture(perform: {
                            if gem.getSocketRarity() < gemSocketMaxRarity {
                                gem.setSocketRarity(socketRarity: gem.getSocketRarity() + 1)
                            }
                        })
                    
                }.padding(15)
                
                Text("SELECT GEM")
                    .font(Font.custom(fontTitles, size: 20))
                    .foregroundColor(Color("Almost Black"))
                    .padding(10)
                
                HStack(spacing: -5) {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 1 ? 1 : 0)
                                                
                        Image(gemLevelOne)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 1 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 1)
                                }
                            })
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 2 ? 1 : 0)
                        
                        Image(gemLevelTwo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 2 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 2)
                                }
                            })
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 3 ? 1 : 0)
                        
                        Image(gemLevelThree)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 3 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 3)
                                }
                            })
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 4 ? 1 : 0)
                        
                        Image(gemLevelFour)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 4 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 4)
                                }
                            })
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 5 ? 1 : 0)
                        
                        Image(gemLevelFive)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 5 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 5)
                                }
                            })
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [selectorColor, .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                            .opacity(gem.getMountedGem() == 6 ? 1 : 0)
                        
                        Image(gemLevelSix)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .onTapGesture(perform: {
                                if gem.getMountedGem() == 6 {
                                    gem.setMountedGem(mountedGem: 0)
                                } else {
                                    gem.setMountedGem(mountedGem: 6)
                                }
                            })
                    }
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Gem:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text(gem.getGemParamsString())
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Socket:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text(gem.getSocketParamsString())
                            .font(Font.custom(fontHeaders, size: 18))
                        
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Total Points:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text(gem.getTotalPointsString())
                            .font(Font.custom(fontTitles, size: 18))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showGemMoreDeets = true
                        }, label: {
                            Text("See Details")
                                .font(Font.custom(fontHeaders, size: 16))
                                .foregroundColor(Color("Gandalf"))
                                .padding(.bottom, 5)
                        })
                    }
                }.frame(maxWidth: 280)
                    .padding(.vertical, 10)
                                    
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color("Almost Black"))
                        .frame(minWidth: 100, maxWidth: 110, minHeight: 38, maxHeight: 38)
                        .padding(.top, 4)
                        .padding(.leading, 4)
                    
                    Button(action: {
                        // in tapAction
                    }, label: {
                        Text("SAVE")
                            .frame(minWidth: 100, maxWidth: 110, minHeight: 38, maxHeight: 38)
                    })
                        .buttonStyle(StartButton(tapAction: {
                            show = false
                        }
                        ))
                        .font(Font.custom(fontButtons, size: 20))
                    
                }
            }   .padding(24)
                .frame(maxWidth: 340)
                .background(Color.white)
                .cornerRadius(15)
            
            if showGemMoreDeets {
                MoreGemDeets(show: $showGemMoreDeets, gem: gem)
            }
        }.ignoresSafeArea()
    }
    
    var selectorColor: Color {
        switch (gem.getSocketType()) {
        case eff:
            return Color(hex: "FFE583")
        case luck:
            return Color(hex: "B6E4F3")
        case comf:
            return Color(hex: "F4A6A6")
        case res:
            return Color(hex: "B8C6F1")
        default:
            return .white
        }
    }
    
    var gemLevelOne: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level1"
        case luck:
            return "gem_luck_level1"
        case comf:
            return "gem_comf_level1"
        case res:
            return "gem_res_level1"
        default:
            return "gem_grey_level1"
        }
    }
    
    var gemLevelTwo: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level2"
        case luck:
            return "gem_luck_level2"
        case comf:
            return "gem_comf_level2"
        case res:
            return "gem_res_level2"
        default:
            return "gem_grey_level2"
        }
    }
    
    var gemLevelThree: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level3"
        case luck:
            return "gem_luck_level3"
        case comf:
            return "gem_comf_level3"
        case res:
            return "gem_res_level3"
        default:
            return "gem_grey_level3"
        }
    }
    
    var gemLevelFour: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level4"
        case luck:
            return "gem_luck_level4"
        case comf:
            return "gem_comf_level4"
        case res:
            return "gem_res_level4"
        default:
            return "gem_grey_level4"
        }
    }
    
    var gemLevelFive: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level5"
        case luck:
            return "gem_luck_level5"
        case comf:
            return "gem_comf_level5"
        case res:
            return "gem_res_level5"
        default:
            return "gem_grey_level5"
        }
    }
    
    var gemLevelSix: String {
        switch (gem.getSocketType()) {
        case eff:
            return "gem_eff_level6"
        case luck:
            return "gem_luck_level6"
        case comf:
            return "gem_comf_level6"
        case res:
            return "gem_res_level6"
        default:
            return "gem_grey_level6"
        }
    }
    
    var gemSocketMaxRarity: Int {
        switch (shoeRarity) {
        case uncommon:
            return 2
        case rare:
            return 3
        case epic:
            return 4
        default:
            return 1
        }
    }
}

struct MoreGemDeets: View {
    @Binding var show: Bool
    
    var gem: Gem

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            
            VStack {
                HStack(spacing: 30) {
                    VStack {
                        Image(gem.getGemImageSource())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, CGFloat(gem.getTopPadding() + 3))
                            .padding(.bottom, CGFloat(gem.getBottomPadding() + 1))
                            .frame(height: 40)
                        
                        Text("Level " + String(gem.getMountedGem()) + " Gem")
                            .font(Font.custom(fontTitles, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Text("+ " + String(percent) + "% base")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                        
                        Text("+ " + String(points) + " points")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                    }
                    
                    VStack {
                        ZStack {
                            Image("gem_socket_gray_0")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color("Gem Socket Shadow"))
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                                .offset(x: 1, y: 1.8)
                            
                            Image(gem.getSocketImageSource())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                            
                            Image("gem_plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                        }
                        
                        Text(socket + " Socket")
                            .font(Font.custom(fontTitles, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Text("Gem Points " + gem.getSocketParamsString())
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                        
                        Text(" ")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                    }
                }
                
                Text(calcString)
                    .font(Font.custom(fontHeaders, size: 17))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.vertical, 10)
                
                Text("\(String(gem.getGemParams())) \(gem.getSocketParamsString()) = \(String(gem.getTotalPoints()))")
                    .font(Font.custom(fontHeaders, size: 17))
                    .foregroundColor(Color("Almost Black"))
        
                Text("Total Points: \t" + gem.getTotalPointsString())
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.vertical, 10)
                
            }.padding(24)
                .frame(maxWidth: 300)
                .background(Color.white)
                .cornerRadius(15)
    
        }.ignoresSafeArea()
            .onTapGesture(perform: {
                withAnimation(.easeOut .speed(1.5)) {
                    show = false
                }
            })
    }
    
    var points: Int {
        switch (gem.getMountedGem()) {
        case 1:
            return 2
        case 2:
            return 8
        case 3:
            return 25
        case 4:
            return 72
        case 5:
            return 200
        case 6:
            return 400
        default:
            return 0
        }
    }
    
    var percent: Int {
        switch (gem.getMountedGem()) {
        case 1:
            return 5
        case 2:
            return 70
        case 3:
            return 220
        case 4:
            return 600
        case 5:
            return 1400
        case 6:
            return 4300
        default:
            return 0
        }
    }
    
    var socket: String {
        switch (gem.getSocketRarity()) {
        case 1:
            return "Uncommon"
        case 2:
            return "Rare"
        case 3:
            return "Epic"
        case 4:
            return "Legendary"
        default:
            return "Common"
        }
    }
    
    var calcString: String {
        return "(\(String(gem.getBasePoints())) × \(String(percent))%) + \(String(points)) = \(String(gem.getGemParams()))"
    }
}

struct GemDialog_Previews: PreviewProvider {
    static var previews: some View {
        GemDialog(
            show: .constant(true),
            gem: .constant(Gem(socketType: 0, socketRarity: 0, mountedGem: 1)),
            shoeRarity: uncommon,
            baseEff: 0,
            baseLuck: 0,
            baseComf: 0,
            baseRes: 0,
            gemEff: .constant(0),
            gemLuck: .constant(0),
            gemComf: .constant(0),
            gemRes: .constant(0)
        )
    }
}
