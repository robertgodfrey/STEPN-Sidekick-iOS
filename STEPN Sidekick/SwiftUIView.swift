//
//  SwiftUIView.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/21/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("1/5")
                .font(Font.custom(fontTitles, size: 16))
                .foregroundColor(Color("Gandalf"))
                .multilineTextAlignment(.leading)
            
            Text("Use the arrow to select a shoe...")
                .font(Font.custom("Roboto-Medium", size: 16))
                .foregroundColor(Color("Gandalf"))
                .multilineTextAlignment(.leading)
            
            HStack {
                Button(action: {
                    print("skippin")
                }, label: {
                    Text("SKIP >")
                })
                .font(Font.custom(fontHeaders, size: 17))
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color("Almost Black"))
                        .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                        .padding(.top, 4)
                        .padding(.leading, 4)
                    
                    Button(action: {
                        print("Next button pressed")
                    }, label: {
                        Text("NEXT")
                            .frame(minWidth: 100, maxWidth: 105, minHeight: 36, maxHeight: 36)
                    })
                        .buttonStyle(StartButton(tapAction: {
                            print("Next button pressed")
                        }
                        ))
                        .font(Font.custom(fontButtons, size: 17))
                }
            }
        }.padding()
            .frame(maxWidth: 310)
            .background(Color.white)
            .cornerRadius(15)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
