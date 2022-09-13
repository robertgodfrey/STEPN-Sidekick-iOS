//
//  Optimizer.swift
//  STEPN Sidekick
//
//  Shoe optimizer. Uses community data to determine best points allocation for GST earning
//  and mystery box chance.
//
//  Created by Rob Godfrey
//
//  Last updated 12 Sep 22
//

import SwiftUI

struct Optimizer: View {
    @Binding var hideTab: Bool
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    
    @State var shoeName = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color("Light Green"))
                    .frame(width: UIScreen.main.bounds.width, height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
                                
                ScrollView {
                    ZStack {
                        Color("Light Green")
                        
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(Color("Almost Black"))
                            .offset(x: 5, y: 5)
                            .padding(.top, 4)
                            .padding(.horizontal, 18)
                            .frame(maxWidth: 500)

                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("Almost Black"), lineWidth: 2)
                                )
                            .padding(.horizontal, 18)
                            .padding(.top, 4)
                            .frame(maxWidth: 500)                    
                                             
                        VStack(spacing: 0){
                            
                            ZStack{
                                Circle()
                                    .foregroundColor(Color(hex: "fcfcfc"))
                                    .frame(height: 190)
                                
                                Circle()
                                    .foregroundColor(Color(hex: "f7f7f7"))
                                    .frame(width: 150)
                                
                                Circle()
                                    .foregroundColor(Color(hex: "ebebeb"))
                                    .frame(width: 110)
                                
                                Image("shoe_walker")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180)
                                
                            }.padding(.vertical, 30)
                                .overlay(
                                    HStack {
                                        ZStack {
                                            Image("gem_socket_gray_0")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(Color("Gem Socket Shadow"))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 42, height: 42)
                                                .padding(.top, 2)
                                                .padding(.leading, 1)
                                            
                                            Image("gem_socket_gray_0")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 42, height: 42)
                                            
                                            Image("")
                                            
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
                                                .frame(width: 42, height: 42)
                                                .padding(.top, 2)
                                                .padding(.leading, 1)
                                            
                                            Image("gem_socket_gray_0")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 42, height: 42)
                                            
                                            Image("")
                                            
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
                                                .frame(width: 42, height: 42)
                                                .padding(.top, 2)
                                                .padding(.leading, 1)
                                            
                                            Image("gem_socket_gray_0")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 42, height: 42)
                                            
                                            Image("")
                                            
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
                                                .frame(width: 42, height: 42)
                                                .padding(.top, 2)
                                                .padding(.leading, 1)
                                            
                                            Image("gem_socket_gray_0")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 42, height: 42)
                                            
                                            Image("")
                                            
                                        }.padding(.bottom, 12)
                                            .padding(.trailing, 45)
                                        
                                    }, alignment: .bottomTrailing
                                )
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .foregroundColor(Color("Almost Black"))
                                    .frame(minWidth: 140, maxWidth: 140, minHeight: 36, maxHeight: 36)
                                    .padding(.top, 4)
                                    .padding(.leading, 4)
                                
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .foregroundColor(Color(hex: "e9e9e9"))
                                    .frame(minWidth: 140, maxWidth: 140, minHeight: 36, maxHeight: 36)
                                    .overlay(RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color("Almost Black"), lineWidth: 1))
                                
                                TextField("Shoe Name", text: $shoeName)
                                    .padding(.trailing, 6)
                                    .frame(minWidth: 150, maxWidth: 157, minHeight: 42, maxHeight: 48)
                                    .font(Font.custom(fontTitles, size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("Almost Black"))
                                
                            }.padding(.top, -10)
                            
                        }
                        
                    }.padding(.bottom, 40)
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
        }   .ignoresSafeArea()
            .preferredColorScheme(.light)
    }
}

struct Optimizer_Previews: PreviewProvider {
    static var previews: some View {
        Optimizer(hideTab: .constant(false))
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
