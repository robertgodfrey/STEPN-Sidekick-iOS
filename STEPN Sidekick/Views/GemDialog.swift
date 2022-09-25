//
//  GemDialog.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 9/25/22.
//

import SwiftUI

struct GemDialog: View {
    
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
    
            
            VStack {
                Text("SELECT SOCKET TYPE")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                
                HStack {
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
                            
                            
                            Image("gem_symbol_efficiency")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
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
                            
                            
                            Image("gem_symbol_luck")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
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
                            
                            
                            Image("gem_symbol_comfort")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
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
                            
                            
                            Image("gem_symbol_res")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                        }
                        Text("Resilience")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                    }
                }
                
                HStack(spacing: 15) {
                    Text("-")
                        .font(Font.custom("Roboto-Black", size: 22))
                        .foregroundColor(Color(1 > 0 ? "Almost Black" : "Gem Socket Shadow"))
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
                                            
                        Image("gem_socket_gray_0")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 46)
                        
                        Image("gem_plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                    }
                    
                    Text("+")
                        .font(Font.custom("Roboto-Black", size: 18))
                        .foregroundColor(Color(1 > 0 ? "Almost Black" : "Gem Socket Shadow"))
                        .frame(width: 50, height: 40)
                        .disabled(1 > 0 ? false : true)
                    
                }.padding(15)
                
                Text("SELECT GEM")
                    .font(Font.custom(fontTitles, size: 18))
                    .foregroundColor(Color("Almost Black"))
                    .padding(10)
                
                HStack(spacing: -10) {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level4")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level5")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "FFE583"), .white]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 25)
                            )
                            .frame(width: 55, height: 55)
                        
                        
                        Image("gem_eff_level6")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Gem:")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("+ 0.0")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Socket:")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("× 0.0")
                            .font(Font.custom(fontHeaders, size: 16))
                        
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Text("Total Points:")
                            .font(Font.custom(fontHeaders, size: 16))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                        Text("+ 0.0")
                            .font(Font.custom(fontTitles, size: 16))
                            .foregroundColor(Color("Almost Black"))
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text("See Details")
                            .font(Font.custom(fontHeaders, size: 14))
                            .foregroundColor(Color("Gandalf"))
                            .padding(.vertical, 5)
                    }
                }.frame(maxWidth: 250)
                    .padding(.vertical, 10)
                                    
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color("Almost Black"))
                        .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                        .padding(.top, 4)
                        .padding(.leading, 4)
                    
                    Button(action: {
                        show = false
                    }, label: {
                        Text("SAVE")
                            .frame(minWidth: 95, maxWidth: 100, minHeight: 36, maxHeight: 36)
                    })
                        .buttonStyle(StartButton(tapAction: {
                            show = false
                        }
                        ))
                        .font(Font.custom(fontButtons, size: 19))
                    
                }
            }   .padding(20)
                .frame(maxWidth: 310)
                .background(Color.white)
                .cornerRadius(15)
        }.ignoresSafeArea()
    }
}

struct GemDialog_Previews: PreviewProvider {
    static var previews: some View {
        GemDialog(show: .constant(true))
    }
}
