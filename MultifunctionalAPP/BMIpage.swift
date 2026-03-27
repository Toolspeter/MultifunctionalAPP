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

    var bmiValue: Double? {
        guard let bmiDouble = Double(bmi) else { return nil }
        return bmiDouble
    }

    var bmiCategory: (category: String, color: Color, advice: String) {
        guard let value = bmiValue else {
            return ("", .gray, "")
        }

        if value < 18.5 {
            return (NSLocalizedString("體重過輕", comment: ""), .blue, NSLocalizedString("建議增加營養攝取，適度運動以增加肌肉量。", comment: ""))
        } else if value < 24 {
            return (NSLocalizedString("正常範圍", comment: ""), .green, NSLocalizedString("保持良好的飲食習慣和規律運動。", comment: ""))
        } else if value < 27 {
            return (NSLocalizedString("體重過重", comment: ""), .orange, NSLocalizedString("建議控制飲食，增加運動量。", comment: ""))
        } else if value < 30 {
            return (NSLocalizedString("輕度肥胖", comment: ""), .orange, NSLocalizedString("建議諮詢營養師，制定減重計畫。", comment: ""))
        } else if value < 35 {
            return (NSLocalizedString("中度肥胖", comment: ""), .red, NSLocalizedString("建議尋求專業醫療協助，進行健康管理。", comment: ""))
        } else {
            return (NSLocalizedString("重度肥胖", comment: ""), .red, NSLocalizedString("強烈建議就醫檢查，制定完整的健康改善計畫。", comment: ""))
        }
    }

    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("BMI介紹", comment: ""))
                    .font(.headline)
                    .foregroundColor(.blue)
                Text(NSLocalizedString("BMI（身體質量指數）是用來評估體重是否健康的指標。", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(NSLocalizedString("根據體重（公斤）和身高（公分）的比例，計算得出。", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                Divider().padding(.vertical, 5)

                Text(NSLocalizedString("BMI值的範圍：", comment: ""))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 5) {
                    BMIRangeRow(range: "< 18.5", category: NSLocalizedString("體重過輕", comment: ""), color: .blue)
                    BMIRangeRow(range: "18.5 - 24", category: NSLocalizedString("正常範圍", comment: ""), color: .green)
                    BMIRangeRow(range: "24 - 27", category: NSLocalizedString("體重過重", comment: ""), color: .orange)
                    BMIRangeRow(range: "27 - 30", category: NSLocalizedString("輕度肥胖", comment: ""), color: .orange)
                    BMIRangeRow(range: "30 - 35", category: NSLocalizedString("中度肥胖", comment: ""), color: .red)
                    BMIRangeRow(range: "≥ 35", category: NSLocalizedString("重度肥胖", comment: ""), color: .red)
                }
            }
            .padding(15)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color:.primary.opacity(0.5),radius: 5)
            .padding()
            HStack() {
                TextField(NSLocalizedString("輸入身高(cm)", comment: ""), text: $height)
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
                TextField(NSLocalizedString("輸入體重(kg)", comment: ""), text: $weight)
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
                weightfocus = false
            }){
                Text(NSLocalizedString("計算 BMI", comment: ""))
                    .foregroundStyle(Color.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal)

            // BMI 結果顯示區
            if let value = bmiValue {
                VStack(spacing: 15) {
                    // BMI 數值卡片
                    VStack(spacing: 10) {
                        Text(NSLocalizedString("您的 BMI", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(String(format: "%.1f", value))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(bmiCategory.color)

                        Text(bmiCategory.category)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(bmiCategory.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bmiCategory.color.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // BMI 視覺化指示器
                    BMIIndicator(bmiValue: value)
                        .padding(.horizontal)

                    // 健康建議
                    if !bmiCategory.advice.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                    .foregroundColor(.red)
                                Text(NSLocalizedString("健康建議", comment: ""))
                                    .font(.headline)
                            }

                            Text(bmiCategory.advice)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .primary.opacity(0.1), radius: 3)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .navigationTitle(NSLocalizedString("BMI Calculator", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture{
            heightfocus = false
            weightfocus = false
        }
    }

    private func BMICalculator() -> String{
        guard let weight_BMI = Double(weight), weight_BMI > 0,
              let height_BMI = Double(height), height_BMI > 0
        else{
            return NSLocalizedString("請輸入數值", comment: "")
        }
        let BMI = weight_BMI / pow(height_BMI / 100, 2)
        return String(format:"%.1f", BMI)
    }
}

// BMI 範圍顯示行
struct BMIRangeRow: View {
    let range: String
    let category: String
    let color: Color

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(range)
                .font(.caption)
                .fontWeight(.medium)
                .frame(width: 70, alignment: .leading)
            Text(category)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// BMI 視覺化指示器
struct BMIIndicator: View {
    let bmiValue: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("BMI 指標", comment: ""))
                .font(.subheadline)
                .fontWeight(.semibold)

            ZStack(alignment: .leading) {
                // 背景漸層條
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .green, .orange, .red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 20)
                .cornerRadius(10)

                // 指示器
                GeometryReader { geometry in
                    let position = calculatePosition(bmiValue: bmiValue, width: geometry.size.width)

                    VStack(spacing: 2) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 16))

                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 2, height: 15)
                    }
                    .offset(x: position - 8)
                }
                .frame(height: 35)
            }

            // 刻度標記
            HStack {
                Text("15")
                    .font(.caption2)
                Spacer()
                Text("20")
                    .font(.caption2)
                Spacer()
                Text("25")
                    .font(.caption2)
                Spacer()
                Text("30")
                    .font(.caption2)
                Spacer()
                Text("35")
                    .font(.caption2)
            }
            .foregroundColor(.gray)
        }
    }

    private func calculatePosition(bmiValue: Double, width: CGFloat) -> CGFloat {
        let minBMI: Double = 15
        let maxBMI: Double = 40
        let clampedBMI = min(max(bmiValue, minBMI), maxBMI)
        let percentage = (clampedBMI - minBMI) / (maxBMI - minBMI)
        return CGFloat(percentage) * width
    }
}

#Preview{
    @State var height: String = ""
    @State var weight: String = ""
    @State var bmi: String = ""
    BMIpage(height: $height, weight: $weight, bmi: $bmi)
}
