//
//  About.swift
//  STEPN Sidekick
//
//  View with information about the app and option to donate.
//
//  Created by Rob Godfrey
//
//  Last updated 3 Sep 22
//

import SwiftUI

struct About: View {
    @Binding var hideTab: Bool
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0

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
                        
                        VStack(spacing: 8) {
                            Text(" ABOUT ")
                                .font(Font.custom(fontTitles, size: 35))
                                .foregroundColor(Color("Almost Black"))
                                .padding(.top, 20)
                            
                            Text("The goal of this app is to make walking and running while using STEPN more enjoyable. Audible alerts allow you to focus on your activity rather than constantly checking your phone.")
                                .font(Font.custom("Roboto-Medium", size: 17))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("Almost Black"))
                                .frame(maxWidth: 400)
                                .padding(.horizontal, 10)
                            
                            HStack {
                                Text("NOTES")
                                    .font(Font.custom(fontTitles, size: 19))
                                    .foregroundColor(Color("Almost Black"))
                                    .padding(0.1)
                                    .padding(.leading, 22)
                                Spacer()
                            }
                            
                            HStack(alignment: .top, spacing: 5) {

                                Text("1.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))

                                Text("It is best to use this app on the same device that is running STEPN so that both apps are using the same location data.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))
                                    .frame(width: 290)
                            }
                            
                            HStack(alignment: .top, spacing: 5) {

                                Text("2.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))

                                Text("STEPN adds a 30-second buffer to every activity. This app's timer accounts for this extra time, but it may not match STEPN's timer exactly.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))
                                    .frame(width: 290)
                            }
                            
                            HStack(alignment: .top, spacing: 5) {

                                Text("3.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))

                                Text("Mystery box chances should be acceptably accurate for levels 1-6, but please do not rely too much on these estimates because they are not precise. Estimates for levels 7-10 will be less accurate; they are difficult to predict due to the lack of available data.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))
                                    .frame(width: 290)
                            }
                            
                            VStack(spacing: 5) {
                                Text("Thanks to:")
                                    .font(Font.custom(fontHeaders, size: 16))
                                    .foregroundColor(Color("Almost Black"))
                                    .padding(.top, 10)
                                    .padding(.bottom, 5)
                                
                                ZStack(alignment: .topLeading) {
                                    Text("                               for gathering invaluable data and sharing with the community.")
                                        .font(Font.custom("Roboto-Regular", size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Link(destination: URL(string: "https://twitter.com/Krit_STEPNstats")!) {
                                            Text("@Krit_STEPNstats")
                                                .font(Font.custom("Roboto-Medium", size: 15))
                                                .foregroundColor(Color("Link Blue"))
                                        }
                                        Spacer()
                                    }
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    Text("                        for gathering and maintaining community HP data.")
                                        .font(Font.custom("Roboto-Regular", size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Link(destination: URL(string: "https://twitter.com/Karl_Khader")!) {
                                            Text("@Karl_Khader")
                                                .font(Font.custom("Roboto-Medium", size: 15))
                                                .foregroundColor(Color("Link Blue"))
                                        }
                                        Spacer()
                                    }
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    Text("              for letting me use his awesome STEPN-style sandal as the \"custom\" shoe image in this app. Check out his page for more great artwork.")
                                        .font(Font.custom("Roboto-Regular", size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Link(destination: URL(string: "https://twitter.com/otik_x")!) {
                                            Text("@otik_x")
                                                .font(Font.custom("Roboto-Medium", size: 15))
                                                .foregroundColor(Color("Link Blue"))
                                        }
                                        Spacer()
                                    }
                                }
                                
                            }.padding(.horizontal, 10)
                            
                            VStack(spacing: 10) {
                                Text("Please contact me if you find any errors or have any suggestions to improve the app:")
                                    .font(Font.custom("Roboto-Regular", size: 15))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("Almost Black"))
                                    .padding(20)
                                
                                Text("sidekickfeedback@gmail.com")
                                    .font(Font.custom("Roboto-Medium", size: 15))
                                    .foregroundColor(Color("Link Blue"))
                                
                                Text("v 1.1")
                                    .font(Font.custom(fontHeaders, size: 13))
                                    .foregroundColor(Color("Gandalf"))
                                    .padding(.vertical, 20)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)

                        }.padding(.horizontal, 30)
                            .frame(maxWidth: 400)
                        
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

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        About(hideTab: .constant(false))
    }
}
