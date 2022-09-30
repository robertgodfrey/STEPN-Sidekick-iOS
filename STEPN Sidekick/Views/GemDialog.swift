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
                        .foregroundColor(Color(1 > 0 ? "Almost Black" : "Gem Socket Shadow"))  //TODO: fix all these
                        .frame(width: 50, height: 40)
                        .disabled(1 > 0 ? false : true)
                    
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
                        
                        Image(gem.getGemImageSource())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, CGFloat(gem.getBottomPadding()))
                            .padding(.top, CGFloat(gem.getTopPadding()))
                            .frame(maxWidth: 32, maxHeight: 32)
                    }
                    
                    Text("+")
                        .font(Font.custom("Roboto-Black", size: 18))
                        .foregroundColor(Color(1 > 0 ? "Almost Black" : "Gem Socket Shadow"))
                        .frame(width: 50, height: 40)
                        .disabled(1 > 0 ? false : true)
                    
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
                                gem.setMountedGem(mountedGem: 1)
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
                                gem.setMountedGem(mountedGem: 2)
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
                                gem.setMountedGem(mountedGem: 3)
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
                                gem.setMountedGem(mountedGem: 4)
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
                                gem.setMountedGem(mountedGem: 5)
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
                                gem.setMountedGem(mountedGem: 6)
                            })
                    }
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Gem:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("+ 0.0")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Socket:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("× 0.0")
                            .font(Font.custom(fontHeaders, size: 18))
                        
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Total Points:")
                            .font(Font.custom(fontHeaders, size: 18))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("+ 0.0")
                            .font(Font.custom(fontTitles, size: 18))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text("See Details")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Gandalf"))
                            .padding(.vertical, 5)
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
                        show = false
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
}

struct GemDialog_Previews: PreviewProvider {
    static var previews: some View {
        GemDialog(show: .constant(true), gem: .constant(Gem(socketType: 0, socketRarity: 0, mountedGem: 1)))
    }
}
