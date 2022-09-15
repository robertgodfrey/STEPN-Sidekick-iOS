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
    
    @State var shoeName: String = ""
    @State var energyString: String = ""
    @State var shoeLevel: Double = 1
    @State var baseEffString: String = ""
    @State var baseLuckString: String = ""
    @State var baseComfString: String = ""
    @State var baseResString: String = ""

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
                            
                            // MARK: Shoe + gems
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
                                            
                                            //Image("") gem/luck/plus goes here
                                            
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
                                            
                                            //Image("")
                                            
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
                                            
                                            //Image("")
                                            
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
                                            
                                            //Image("")
                                            
                                        }.padding(.bottom, 12)
                                            .padding(.trailing, 45)
                                        
                                    }, alignment: .bottomTrailing
                                )
                            
                            // MARK: Shoe name
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
                            
                            // MARK: Shoe selector
                            HStack(spacing: 20) {
                                Image("arrow_left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                
                                Text("1")
                                    .font(Font.custom(fontHeaders, size: 15))
                                    .foregroundColor(Color("Gandalf"))
                                
                                Text("2")
                                    .font(Font.custom(fontTitles, size: 17))
                                    .foregroundColor(Color("Almost Black"))
                                
                                Text("3")
                                    .font(Font.custom(fontHeaders, size: 15))
                                    .foregroundColor(Color("Gandalf"))
                                
                                Image("arrow_right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                            }.padding(5)
                            
                            HStack(spacing: 0) {
                                // MARK: Rarity stack
                                VStack(spacing: 0) {
                                    Text("Rarity")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                            .padding([.top, .leading], 5)
                                    
                                        Button(action: {
                                            // action goes here
                                            UIApplication.shared.hideKeyboard()
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .foregroundColor(Color(hex: "e9e9e9"))
                                                    .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("Almost Black"), lineWidth: 1))
                                                
                                                Text("Common")
                                                    .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                        })
                                        .font(Font.custom(fontButtons, size: 17))
                                    }
                                }
                                
                                // MARK: Type stack
                                VStack(spacing: 0) {
                                    Text("Type")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                            .padding([.top, .leading], 5)
                                    
                                        Button(action: {
                                            // action goes here
                                            UIApplication.shared.hideKeyboard()
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .foregroundColor(Color(hex: "e9e9e9"))
                                                    .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("Almost Black"), lineWidth: 1))
                                                
                                                Text("Walker")
                                                    .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                                    .foregroundColor(Color("Almost Black"))
                                            }
                                        })
                                        .font(Font.custom(fontButtons, size: 17))
                                    }
                                }
                                
                                // MARK: Energy stack
                                VStack(spacing: 0) {
                                    Text("100% Energy")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(Color("Energy Blue Border"))
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                            .padding([.top, .leading], 5)
                                     
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .foregroundColor(Color("Energy Blue"))  // TODO: or energy blue lighter
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                            .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color("Energy Blue Border"), lineWidth: 1))
                                        
                                        Image("energy_bolt")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.trailing, 14)
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 20, maxHeight: 20, alignment: .trailing)
                                        
                                        TextField("0.0", text: $energyString)
                                            .padding(.trailing, 6)
                                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                                            .font(Font.custom(fontTitles, size: 18))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                                    }
                                }
                            }
                            
                            ZStack {
                                // TODO: create custom slider view
                                Slider(value: $shoeLevel, in: 1...30)
                                    .frame(minWidth: 300, maxWidth: 315, minHeight: 20, maxHeight: 20)
                                
                                HStack {
                                    Text("Level 1")
                                        .font(Font.custom(fontTitles, size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .padding(.leading, 40)
                                        
                                    Spacer()
                                }
                                
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
                            }.frame(minWidth: 300, maxWidth: 315)
                                .padding(.vertical, 15)
                            
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
                                        
                                        TextField("0.0", text: $baseEffString)
                                            .font(Font.custom(fontHeaders, size: 19))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                        
                                        Text("0.0")
                                            .font(Font.custom(fontTitles, size: 22))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.frame(minWidth: 300, maxWidth: 315)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 28))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 22))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                    }.frame(minWidth: 340, maxWidth: 355)
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

                                        TextField("0.0", text: $baseLuckString)
                                            .font(Font.custom(fontHeaders, size: 19))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                        
                                        Text("0.0")
                                            .font(Font.custom(fontTitles, size: 22))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.frame(minWidth: 300, maxWidth: 315)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 28))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 22))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                    }.frame(minWidth: 340, maxWidth: 355)
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
                                        
                                        TextField("0.0", text: $baseComfString)
                                            .font(Font.custom(fontHeaders, size: 19))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 95)
                                        
                                        Text("0.0")
                                            .font(Font.custom(fontTitles, size: 22))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 90)
                                    }.frame(minWidth: 300, maxWidth: 315)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 28))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 22))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                    }.frame(minWidth: 340, maxWidth: 355)
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
                                        
                                        TextField("0.0", text: $baseResString)
                                            .font(Font.custom(fontHeaders, size: 19))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .keyboardType(.decimalPad)
                                            .frame(width: 85)
                                        
                                        Text("0.0")
                                            .font(Font.custom(fontTitles, size: 22))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("Almost Black"))
                                            .frame(width: 95)
                                    }.frame(minWidth: 300, maxWidth: 315)
                                    
                                    HStack(spacing: 30) {
                                        Spacer()
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("-")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 28))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                        
                                        Button(action: {
                                            // action goes here
                                        }, label: {
                                            Text("+")
                                                .font(Font.custom("RobotoCondensed-Bold", size: 22))
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(width: 50, height: 40)
                                        })
                                    }.frame(minWidth: 340, maxWidth: 355)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("Points Avaiable: ")
                                        .font(Font.custom(fontHeaders, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                    
                                    Text("0")
                                        .font(Font.custom(fontTitles, size: 16))
                                        .foregroundColor(Color("Gandalf"))
                                        .padding(.trailing, 5)
                                    
                                }.frame(minWidth: 300, maxWidth: 315)
                            }
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
