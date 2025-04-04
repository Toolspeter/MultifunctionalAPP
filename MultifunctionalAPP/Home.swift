//
//  Home.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI
import MapKit

struct Home:View{
    @Binding var height :String
    @Binding var weight : String
    @Binding var bmi :String
    @Binding var isOn : Bool
    @State var menu : Bool = false
    let Lacotion = CLLocationManager()
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
                        NavigationLink(destination: {
                            G1A2Bpage()
                        }, label: {
                            Text("1A2B(開發中)")
                        })
//                        Text("1Ａ2Ｂ(開發中)")
                    
                    }
                }.navigationTitle("首頁")
            }
        }
        .onAppear(){
            Lacotion.requestWhenInUseAuthorization()
        }
    }
}

#Preview{
    ContentView()
}
