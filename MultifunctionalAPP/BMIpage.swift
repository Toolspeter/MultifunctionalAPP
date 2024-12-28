//
//  BMIpage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct BMIpage: View{
    @Binding var height : String
    @Binding var weight: String
    @Binding var bmi:String
    var body: some View{
        VStack {
//            Text("BMI計算器").padding()
            VStack(alignment: .leading, spacing: 10) {
                Text("BMI介紹")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("BMI（身體質量指數）是用來評估體重是否健康的指標。")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("根據體重（公斤）和身高（公分）的比例，計算得出。")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Text("BMI值的範圍：")
                Text("低於18.5：體重過輕")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("18.5~24.9：正常")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("25~29.9：體重過重")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background()
            .cornerRadius(12)
            .shadow(color:.primary.opacity(0.5),radius: 5)
            .padding(.horizontal)
            ZStack(alignment: .trailing){
                TextField("輸入身高(cm)", text: $height)
                    .keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                if !height.isEmpty {
                    Button(action:{
                        height = ""
                    }){
                        Image(systemName:"xmark.circle.fill").foregroundColor(Color.gray)
                    }.padding(.trailing,20)
                }
            }
            ZStack(alignment:.trailing){
                TextField("輸入體重(kg)", text: $weight).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                if !weight.isEmpty {
                    Button(action:{
                        weight = ""
                    }){
                        Image(systemName:"xmark.circle.fill").foregroundColor(Color.gray)
                    }.padding(.trailing,20)
                }
            }
                Button(action: {
                    bmi = BMICalculator()}
                ){
                    Text("計算 BMI").foregroundStyle(Color.white).padding()
                }.background(Color.blue)
                    .cornerRadius(8)
                Text("BMI: \(bmi)").padding()
                Spacer()
            
        }.navigationTitle("BMI計算器")
            .navigationBarTitleDisplayMode(.inline)
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
