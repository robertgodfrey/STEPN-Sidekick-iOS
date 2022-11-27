//
//  UpdateDialog.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 10/8/22.
//

import SwiftUI

struct UpdateDialog: View {
    
    @Binding var show: Bool

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            
            VStack(spacing: 0) {
                Text("UPDATE")
                    .font(Font.custom(fontTitles, size: 20))
                    .foregroundColor(Color("Gandalf"))
                
                VStack(spacing: 10) {
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("USD estimates are now available at the bottom of the shoe optimizer")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("The \"Optimize GMT\" button is now functional")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    /*
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("There is now a paid option to remove ads in the \"About\" section")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    */
                    Text("If you have been enjoying the app, please consider leaving a review in the App Store!")
                        .font(Font.custom(fontRegText, size: 17))
                        .foregroundColor(Color("Almost Black"))
                    
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
                        Text("OKAY")
                            .frame(minWidth: 100, maxWidth: 110, minHeight: 38, maxHeight: 38)
                    })
                        .buttonStyle(StartButton(tapAction: {
                            show = false
                        }
                        ))
                        .font(Font.custom(fontButtons, size: 20))
                    
                }.padding(.top, 10)
            }   .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .frame(maxWidth: 340)
                .background(Color.white)
                .cornerRadius(15)

        }.ignoresSafeArea()
    }
}

struct UpdateDialog_Previews: PreviewProvider {
    static var previews: some View {
        UpdateDialog(show: .constant(true))
    }
}
