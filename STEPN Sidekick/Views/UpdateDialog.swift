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
                    
                        Text("You can now switch between calculating earnings for GST or GMT.")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("Because GMT earnings vary so widely, estimated GMT earnings are displayed as a range. The number at the bottom is the average expected earning.")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("Optimizing GMT will come in a later update, along with other GMT-related features.")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
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
