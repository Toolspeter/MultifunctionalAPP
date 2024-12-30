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
    @FocusState var heightfocus: Bool
    @FocusState var weightfocus: Bool
    var body: some View{
        ScrollView {
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
            .padding(10)
            .background()
            .cornerRadius(12)
            .shadow(color:.primary.opacity(0.5),radius: 5)
            .padding()
            HStack() {
                TextField("輸入身高(cm)", text: $height)
                    .focused($heightfocus)
                    .padding(.vertical,4).padding(.leading,4)
                    .keyboardType(.decimalPad)
                if !height.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                        .onTapGesture {
                            height = ""
                        }
                }
            }
            .background()
            .cornerRadius(8)
            .padding()
            .shadow(color: .primary, radius: 1)
            HStack() {
                TextField("輸入體重(kg)", text: $weight)
                    .keyboardType(.decimalPad)
                    .focused($weightfocus)
                    .padding(.vertical,4).padding(.leading,4)
                if !weight.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                        .onTapGesture {
                            weight = ""
                        }
                }
            }
            .background()
            .cornerRadius(8)
            .padding()
            .shadow(color: .primary, radius: 1)
            Button(action: {
                bmi = BMICalculator()
                heightfocus = false
                weightfocus = false}
            ){
                Text("計算 BMI").foregroundStyle(Color.white).padding()
            }.background(Color.blue)
                .cornerRadius(8)
            Text("BMI: \(bmi)").padding()
            Spacer()
            
        }
        .navigationTitle("BMI計算器")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture{
            heightfocus = false
            weightfocus = false
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
    
//    func hideKeyboard(){
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
}

#Preview{
    @State var height: String = ""
    @State var weight: String = ""
    @State var bmi: String = ""
    BMIpage(height: $height, weight: $weight, bmi: $bmi)
}
