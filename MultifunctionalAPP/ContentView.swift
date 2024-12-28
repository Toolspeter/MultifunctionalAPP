//
//  ContentView.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct ContentView: View {
    @State var height : String = ""
    @State var weight : String = ""
    @State var bmi : String = ""
    @State var selected : Int = 0

    
    var body: some View {
        TabView{
            Home(height: $height, weight: $weight, bmi:$bmi)
                .tabItem{Label("首頁",systemImage: "house")}
            Setting()
                .tabItem{Label("設定", systemImage: "gear")
            }
        }
        }
    }

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

struct Home:View{
    @Binding var height :String
    @Binding var weight : String
    @Binding var bmi :String
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

struct BMIpage: View{
    @Binding var height : String
    @Binding var weight: String
    @Binding var bmi:String
    var body: some View{
        VStack{
            Text("BMI計算器").padding()
            TextField("輸入身高(cm)", text: $height)
                .keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            TextField("輸入體重(kg)", text: $weight).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            Button(action: {
                bmi = BMICalculator()}
            ){
                Text("計算 BMI").foregroundStyle(Color.white).padding()
            }.background(Color.blue)
            .cornerRadius(8)
            Text("BMI: \(bmi)").padding()
            Spacer()
        }
    }
    private func BMICalculator() -> String{
        guard let weight_BMI =
                Double(weight), weight_BMI > 0,
              let height_BMI =
                Double(height), height_BMI > 0
        else{
            return "請輸入數值"
        }
        let BMI = weight_BMI / pow(height_BMI / 100,2)
        return String(format:"%.2f",BMI)
    }
}

#Preview {
    ContentView()
}
