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
                    
                        Text("Mystery box probabilities are now displayed to give a better idea of what level of box you can expect")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }

                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("Probabilities are based on a prediction model that uses community data gathered by the gam3.fi team")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Text("Theses predictions are not perfect and will continue to improve as more data is analyzed")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()
                        
                    }

                    HStack(alignment: .top) {
                        Text("•")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                    
                        Text("GMT earning estimates have been updated (and will be updated more often in the future)")
                            .font(Font.custom(fontRegText, size: 17))
                            .foregroundColor(Color("Almost Black"))
                        
                        Spacer()

                    }
                    
                    Text("If you have been enjoying the app, please consider leaving a review on the App Store!")
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
