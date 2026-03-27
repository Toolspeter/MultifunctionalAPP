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
    @State var isOn : Bool = false
    var body: some View {
        TabView(selection: $selected){
            Home(height: $height, weight: $weight, bmi:$bmi,isOn:$isOn)
                .tabItem{
                    Label(NSLocalizedString("Home", comment: ""), systemImage: "house.fill")
                }
                .tag(0)
            Setting()
                .tabItem{
                    Label(NSLocalizedString("Setting", comment: ""), systemImage: "gear")
                }
                .tag(1)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
