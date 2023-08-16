//
//  About.swift
//  STEPN Sidekick
//
//  View with information about the app and option to donate.
//
//  Created by Rob Godfrey
//
//  Last updated 26 Feb 23
//

import SwiftUI

struct About: View {
    @Binding var hideTab: Bool
    @Binding var showAds: Bool
    
    @State private var showAlert: Bool = false
    @State private var loadingRestore: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @EnvironmentObject var storeManager: StoreManager
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0

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
                VStack(spacing: 20) {
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
                            
                            Text("The main goal of this app is to make moving-to-earn more enjoyable. Audible alerts allow you to focus on your activity rather than constantly checking your phone.")
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

                                Text("GMT earnings are always changing and are difficult to predict. This app's estimate gives you an idea of the earning range to expect but is not precise.")
                                    .font(Font.custom("Roboto-Regular", size: 17))
                                    .foregroundColor(Color("Almost Black"))
                                    .frame(width: 290)
                            }
                            
                            if showAds {
                                if storeManager.transactionState == .purchasing || loadingRestore {
                                    ProgressView()
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                } else {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                                .foregroundColor(Color("Almost Black"))
                                                .frame(minWidth: 175, maxWidth: 180, minHeight: 45, maxHeight: 45)
                                                .padding(.top, 6)
                                                .padding(.leading, 6)
                                            
                                            Button(action: {
                                                // in tapAction
                                            }, label: {
                                                Text("REMOVE ADS")
                                                    .frame(minWidth: 175, maxWidth: 180, minHeight: 45, maxHeight: 45)
                                            })
                                            .buttonStyle(StartButton(tapAction: {
                                                showAds = !UserDefaults.standard.bool(forKey: "remove_ads")
                                                if showAds {
                                                    storeManager.purchaseProduct(product: storeManager.myProducts[0])
                                                }
                                            })).font(Font.custom(fontButtons, size: 20))
                                            
                                        }
                                        Text("Restore purchase")
                                            .font(Font.custom("Roboto-Regular", size: 13))
                                            .foregroundColor(Color("Link Blue"))
                                            .onTapGesture(perform: {
                                                showAds = !UserDefaults.standard.bool(forKey: "remove_ads")
                                                if showAds {
                                                    loadingRestore = true
                                                    storeManager.restoreProducts()
                                                    DispatchQueue.global(qos: .background).async {
                                                        sleep(3)
                                                        showAds = !UserDefaults.standard.bool(forKey: "remove_ads")
                                                        if showAds {
                                                            alertTitle = "Unable to Restore Purchase"
                                                            alertMessage = "No previous purchase found. If you believe this is an error, please try restoring again."
                                                        } else {
                                                            alertTitle = "Purchase Restored"
                                                            alertMessage = "Purchase successfully restored. Thank you!"
                                                        }
                                                        showAlert = true
                                                        loadingRestore = false
                                                    }
                                                    
                                                }
                                            })
                                        
                                    }.padding(.top, 16)
                                        .padding(.bottom, 8)
                                }
                            } else {
                                Text("Thank you for removing ads! ❤")
                                    .font(Font.custom("Roboto-Regular", size: 15))
                                    .foregroundColor(Color("Almost Black"))
                                    .padding(.top, 14)
                                    .padding(.bottom, 8)
                            }
                            
                            VStack(spacing: 5) {
                                Text("Thanks to:")
                                    .font(Font.custom(fontHeaders, size: 16))
                                    .foregroundColor(Color("Almost Black"))
                                    .padding(.top, 10)
                                    .padding(.bottom, 5)
                                
                                ZStack(alignment: .topLeading) {
                                    Text("                         for gathering invaluable data and sharing with the community.")
                                        .font(Font.custom("Roboto-Regular", size: 15))
                                        .foregroundColor(Color("Almost Black"))
                                        .fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Link(destination: URL(string: "https://twitter.com/KuritoSensei")!) {
                                            Text("@KuritoSensei")
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
                                    Text("              for letting me use his awesome STEPN-style sandal as the \"custom\" shoe image in this app.")
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
                                
                                Link(destination: URL(string: "mailto:sidekickfeedback@gmail.com")!) {
                                    Text("sidekickfeedback@gmail.com")
                                        .font(Font.custom("Roboto-Medium", size: 15))
                                        .foregroundColor(Color("Link Blue"))
                                }
                                
                                Text("v 1.4.4")
                                    .font(Font.custom(fontHeaders, size: 13))
                                    .foregroundColor(Color("Gandalf"))
                                    .padding(.vertical, 20)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)

                        }.padding(.horizontal, 30)
                            .frame(maxWidth: 400)
                    }
                    
                    ZStack {
                    
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
                        
                        VStack(spacing: 24) {
                            Text("MORE COMMUNITY TOOLS")
                                .font(Font.custom(fontTitles, size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("Almost Black"))
                                .padding(.top, 20)
                                .frame(width: 260)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            VStack {
                                Link(destination: URL(string: "https://stepn-market.guide/")!) {
                                    Image("stepn_market_guide")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300)
                                }
                                Text("Improved marketplace filter & price tracker by")
                                    .font(Font.custom("Roboto-Regular", size: 13))
                                    .foregroundColor(Color("Almost Black"))
                                
                                Link(destination: URL(string: "https://twitter.com/t2_stepn")!) {
                                    Text("@t2_stepn")
                                        .font(Font.custom("Roboto-Medium", size: 13))
                                        .foregroundColor(Color("Link Blue"))
                                }
                            }.padding(.top, 5)
                         
                            VStack {
                                Link(destination: URL(string: "https://www.gam3.fi/stepn/mb-chart/")!) {
                                    Image("gamefi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 210)
                                }
                                HStack(spacing: 4) {
                                    Text("Web3 gaming aggregator by")
                                        .font(Font.custom("Roboto-Regular", size: 13))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Link(destination: URL(string: "https://twitter.com/gam3_fi")!) {
                                        Text("@gam3_fi")
                                            .font(Font.custom("Roboto-Medium", size: 13))
                                            .foregroundColor(Color("Link Blue"))
                                    }
                                }
                                Text("Click logo to see the latest mystery box charts")
                                    .font(Font.custom("Roboto-Regular", size: 13))
                                    .foregroundColor(Color("Almost Black"))
                                    
                            }
                            
                            VStack {
                                Link(destination: URL(string: "https://stepnfp.com/")!) {
                                    Image("stepn_fp")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 270)
                                }
                                
                                Text("Shoe, gem, and scroll floor price tracker by")
                                    .font(Font.custom("Roboto-Regular", size: 13))
                                    .foregroundColor(Color("Almost Black"))
                                
                                Link(destination: URL(string: "https://twitter.com/StepnFP")!) {
                                    Text("@StepnFP")
                                        .font(Font.custom("Roboto-Medium", size: 13))
                                        .foregroundColor(Color("Link Blue"))
                                        .padding(.top, -5)
                                }
                            }.padding(.top, 5)
                            
                            VStack {
                                Link(destination: URL(string: "https://stepn.wiki/")!) {
                                    Image("stepn_wiki")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 250)
                                }
                                
                                HStack(spacing: 4) {
                                    Text("GST, ROI, and gems simulator by")
                                        .font(Font.custom("Roboto-Regular", size: 13))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Link(destination: URL(string: "https://twitter.com/STEPNwiki")!) {
                                        Text("@STEPNwiki")
                                            .font(Font.custom("Roboto-Medium", size: 13))
                                            .foregroundColor(Color("Link Blue"))
                                    }
                                }
                            }
                            
                            VStack {
                                Link(destination: URL(string: "https://stepn.vanxh.dev/")!) {
                                    Image("stepn_assist")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 260)
                                        .padding(.top, 5)
                                }
                                
                                HStack(spacing: 4) {
                                    Text("Mint price calculator by")
                                        .font(Font.custom("Roboto-Regular", size: 13))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Link(destination: URL(string: "https://twitter.com/Vanxhh")!) {
                                        Text("@Vanxhh")
                                            .font(Font.custom("Roboto-Medium", size: 13))
                                            .foregroundColor(Color("Link Blue"))
                                    }
                                }
                            }
                            
                            VStack {
                                Link(destination: URL(string: "https://stepn.guide/")!) {
                                    Image("stepn_guide")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 260)
                                }
                                
                                HStack(spacing: 4) {
                                    Text("The OG sneaker optimizer by")
                                        .font(Font.custom("Roboto-Regular", size: 13))
                                        .foregroundColor(Color("Almost Black"))
                                    
                                    Link(destination: URL(string: "https://twitter.com/Stepappturkey")!) {
                                        Text("@Stepappturkey")
                                            .font(Font.custom("Roboto-Medium", size: 13))
                                            .foregroundColor(Color("Link Blue"))
                                    }
                                }
                            }.padding(.bottom, 8)
                                .padding(.top, 6)
                            
                        }.frame(maxWidth: 400)
                            .padding(.bottom, 30)
                    }
                    
                }.padding(.bottom, 40)
                .padding(.top, 5)
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
            }.padding(.top, (showAds ? (UIDevice.current.userInterfaceIdiom == .pad ? 90 : 50) : 0) + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 1)
                .onAppear(perform: {
                    print("remove_ads")
                    print(UserDefaults.standard.bool(forKey: "remove_ads"))
                    print("\n\nProducts:")
                    print(storeManager.myProducts)
                    print("\n\n")
                })
        }   .ignoresSafeArea()
            .preferredColorScheme(.light)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("Okay")))
            }
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        About(hideTab: .constant(false), showAds: .constant(false))
    }
}
