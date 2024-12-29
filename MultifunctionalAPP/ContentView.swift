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
    @State var bmi : String = "輸入數值以計算"
    @State var selected : Int = 0
    @State var isOn : Bool = false

    
    var body: some View {
        TabView{
            Home(height: $height, weight: $weight, bmi:$bmi,isOn:$isOn)
                .tabItem{Label("首頁",systemImage: "house")}
            Setting()
                .tabItem{Label("設定", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
}
