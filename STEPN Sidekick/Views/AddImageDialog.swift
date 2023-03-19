//
//  AddImageDialog.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 3/18/23.
//

import SwiftUI

struct AddImageDialog: View {
    
    @Binding var show: Bool
    @Binding var url: String

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            
            VStack(spacing: 20) {
                Text("ADD CUSTOM SHOE IMAGE")
                    .font(Font.custom(fontTitles, size: 20))
                    .foregroundColor(Color("Almost Black"))
        
                Text("Paste the URL of an image of your shoe:")
                    .font(Font.custom(fontRegText, size: 16))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.horizontal, 10)
                
                TextField("Image URL", text: $url)
                    .font(Font.custom(fontRegText, size: 15))
                    .multilineTextAlignment(.center)
                    .keyboardType(.webSearch)
                    .foregroundColor(Color("Almost Black"))
                    .padding(.horizontal, 10)

                                    
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
                    
                }.padding(.bottom, 5)
                
                Text("Note: For best results, use a PNG file with a transparent background. To use your actual shoe image, log in to the STEPN marketplace in a web browser, go to your inventory, right click the image of your shoe, and select 'Copy Image Link'.")
                    .font(Font.custom(fontRegText, size: 15))
                    .foregroundColor(Color("Almost Black"))
                    .padding(.horizontal, 10)
                
            }   .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(15)

        }.ignoresSafeArea()
    }
}

struct AddImageDialog_Previews: PreviewProvider {
    static var previews: some View {
        AddImageDialog(show: .constant(true), url: .constant("hehe"))
    }
}
