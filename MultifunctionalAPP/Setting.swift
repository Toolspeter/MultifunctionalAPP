//
//  Setting.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct Setting:View{
    var body:some View{
        VStack{
            NavigationView {
                List{
                    Section(header: Text("關於")){
                        HStack{
                            Spacer()
                            VStack{
                                Image("Icon")
                                    .resizable().frame(width:60,height:60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color:.primary.opacity(0.5)
                                            ,radius: 11,x: 1, y: 1)
                                Text("多功能APP").padding(5)
                                Text("Version:1.0.0").padding(5)
                                Text("Copyright © 2024 Toolspeter").padding(5)
                            }
                            Spacer()
                        }
                    }
                }.navigationTitle("設定")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ContentView()
}
