//
//  Home.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct Home:View{
    @Binding var height :String
    @Binding var weight : String
    @Binding var bmi :String
    @Binding var isOn : Bool
    @State var menu : Bool = false
    var body: some View{
        VStack{
            NavigationView{
                List{
                    Section(header: Text("小工具")){
                        NavigationLink(destination: BMIpage(
                            height:$height,
                            weight:$weight,
                            bmi: $bmi)){
                                Text("BMI計算器")
                            }
                            }
                    Section(header: Text("小遊戲")){
                        Text("1Ａ2Ｂ(開發中)")
                    }
                }.navigationTitle("首頁")
            }
        
        }
    }
}

#Preview{
    ContentView()
}
