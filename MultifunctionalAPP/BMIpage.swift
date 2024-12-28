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
