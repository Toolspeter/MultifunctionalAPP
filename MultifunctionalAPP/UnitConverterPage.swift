//
//  UnitConverterPage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

enum ConversionType: String, CaseIterable {
    case length = "長度"
    case weight = "重量"
    case temperature = "溫度"
    case area = "面積"

    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    var icon: String {
        switch self {
        case .length: return "ruler"
        case .weight: return "scalemass"
        case .temperature: return "thermometer"
        case .area: return "square.grid.2x2"
        }
    }
}

struct UnitConverterPage: View {
    @State private var selectedType: ConversionType = .length
    @State private var inputValue: String = ""
    @State private var fromUnit: String = ""
    @State private var toUnit: String = ""
    @FocusState private var isInputFocused: Bool

    var convertedValue: String {
        guard let value = Double(inputValue), !fromUnit.isEmpty, !toUnit.isEmpty else {
            return "---"
        }

        let result = performConversion(value: value, from: fromUnit, to: toUnit, type: selectedType)
        return String(format: "%.4f", result)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 類型選擇器
                Picker(NSLocalizedString("轉換類型", comment: ""), selection: $selectedType) {
                    ForEach(ConversionType.allCases, id: \.self) { type in
                        Text(type.localizedName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedType) { newValue in
                    fromUnit = getUnits(for: newValue).first ?? ""
                    toUnit = getUnits(for: newValue).last ?? ""
                }

                // 圖示顯示
                HStack(spacing: 10) {
                    Image(systemName: selectedType.icon)
                        .font(.title)
                        .foregroundColor(.blue)
                    Text(selectedType.localizedName)
                        .font(.title2)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal)

                // 輸入區域
                VStack(spacing: 15) {
                    HStack {
                        TextField(NSLocalizedString("輸入數值", comment: ""), text: $inputValue)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                            .font(.title2)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        if !inputValue.isEmpty {
                            Button(action: { inputValue = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // 來源單位選擇
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("從", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Picker(NSLocalizedString("從", comment: ""), selection: $fromUnit) {
                            ForEach(getUnits(for: selectedType), id: \.self) { unit in
                                Text(NSLocalizedString(unit, comment: "")).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // 轉換圖標
                    Image(systemName: "arrow.down")
                        .font(.title)
                        .foregroundColor(.blue)

                    // 目標單位選擇
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("到", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Picker(NSLocalizedString("到", comment: ""), selection: $toUnit) {
                            ForEach(getUnits(for: selectedType), id: \.self) { unit in
                                Text(NSLocalizedString(unit, comment: "")).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                // 結果顯示
                VStack(spacing: 10) {
                    Text(NSLocalizedString("轉換結果", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(convertedValue)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)

                    if !convertedValue.isEmpty && convertedValue != "---" {
                        Text("\(inputValue) \(fromUnit) = \(convertedValue) \(toUnit)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: .primary.opacity(0.1), radius: 5)
                .padding()

                Spacer()
            }
        }
        .navigationTitle(NSLocalizedString("Unit Converter", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fromUnit = getUnits(for: selectedType).first ?? ""
            toUnit = getUnits(for: selectedType).last ?? ""
        }
        .onTapGesture {
            isInputFocused = false
        }
    }

    private func getUnits(for type: ConversionType) -> [String] {
        switch type {
        case .length:
            return [
                NSLocalizedString("公尺 (m)", comment: ""),
                NSLocalizedString("公分 (cm)", comment: ""),
                NSLocalizedString("公里 (km)", comment: ""),
                NSLocalizedString("英吋 (in)", comment: ""),
                NSLocalizedString("英尺 (ft)", comment: ""),
                NSLocalizedString("碼 (yd)", comment: ""),
                NSLocalizedString("英里 (mi)", comment: "")
            ]
        case .weight:
            return [
                NSLocalizedString("公斤 (kg)", comment: ""),
                NSLocalizedString("公克 (g)", comment: ""),
                NSLocalizedString("毫克 (mg)", comment: ""),
                NSLocalizedString("磅 (lb)", comment: ""),
                NSLocalizedString("盎司 (oz)", comment: ""),
                NSLocalizedString("噸 (t)", comment: "")
            ]
        case .temperature:
            return [
                NSLocalizedString("攝氏 (°C)", comment: ""),
                NSLocalizedString("華氏 (°F)", comment: ""),
                NSLocalizedString("克氏 (K)", comment: "")
            ]
        case .area:
            return [
                NSLocalizedString("平方公尺 (m²)", comment: ""),
                NSLocalizedString("平方公分 (cm²)", comment: ""),
                NSLocalizedString("平方公里 (km²)", comment: ""),
                NSLocalizedString("公頃 (ha)", comment: ""),
                NSLocalizedString("英畝 (ac)", comment: ""),
                NSLocalizedString("平方英尺 (ft²)", comment: "")
            ]
        }
    }

    private func performConversion(value: Double, from: String, to: String, type: ConversionType) -> Double {
        if from == to { return value }

        switch type {
        case .length:
            return convertLength(value: value, from: from, to: to)
        case .weight:
            return convertWeight(value: value, from: from, to: to)
        case .temperature:
            return convertTemperature(value: value, from: from, to: to)
        case .area:
            return convertArea(value: value, from: from, to: to)
        }
    }

    private func convertLength(value: Double, from: String, to: String) -> Double {
        let toMeters: [String: Double] = [
            NSLocalizedString("公尺 (m)", comment: ""): 1.0,
            NSLocalizedString("公分 (cm)", comment: ""): 0.01,
            NSLocalizedString("公里 (km)", comment: ""): 1000.0,
            NSLocalizedString("英吋 (in)", comment: ""): 0.0254,
            NSLocalizedString("英尺 (ft)", comment: ""): 0.3048,
            NSLocalizedString("碼 (yd)", comment: ""): 0.9144,
            NSLocalizedString("英里 (mi)", comment: ""): 1609.344
        ]

        let meters = value * (toMeters[from] ?? 1.0)
        return meters / (toMeters[to] ?? 1.0)
    }

    private func convertWeight(value: Double, from: String, to: String) -> Double {
        let toKilograms: [String: Double] = [
            NSLocalizedString("公斤 (kg)", comment: ""): 1.0,
            NSLocalizedString("公克 (g)", comment: ""): 0.001,
            NSLocalizedString("毫克 (mg)", comment: ""): 0.000001,
            NSLocalizedString("磅 (lb)", comment: ""): 0.453592,
            NSLocalizedString("盎司 (oz)", comment: ""): 0.0283495,
            NSLocalizedString("噸 (t)", comment: ""): 1000.0
        ]

        let kg = value * (toKilograms[from] ?? 1.0)
        return kg / (toKilograms[to] ?? 1.0)
    }

    private func convertTemperature(value: Double, from: String, to: String) -> Double {
        var celsius: Double

        switch from {
        case NSLocalizedString("攝氏 (°C)", comment: ""):
            celsius = value
        case NSLocalizedString("華氏 (°F)", comment: ""):
            celsius = (value - 32) * 5/9
        case NSLocalizedString("克氏 (K)", comment: ""):
            celsius = value - 273.15
        default:
            celsius = value
        }

        switch to {
        case NSLocalizedString("攝氏 (°C)", comment: ""):
            return celsius
        case NSLocalizedString("華氏 (°F)", comment: ""):
            return celsius * 9/5 + 32
        case NSLocalizedString("克氏 (K)", comment: ""):
            return celsius + 273.15
        default:
            return celsius
        }
    }

    private func convertArea(value: Double, from: String, to: String) -> Double {
        let toSquareMeters: [String: Double] = [
            NSLocalizedString("平方公尺 (m²)", comment: ""): 1.0,
            NSLocalizedString("平方公分 (cm²)", comment: ""): 0.0001,
            NSLocalizedString("平方公里 (km²)", comment: ""): 1000000.0,
            NSLocalizedString("公頃 (ha)", comment: ""): 10000.0,
            NSLocalizedString("英畝 (ac)", comment: ""): 4046.86,
            NSLocalizedString("平方英尺 (ft²)", comment: ""): 0.092903
        ]

        let sqm = value * (toSquareMeters[from] ?? 1.0)
        return sqm / (toSquareMeters[to] ?? 1.0)
    }
}

#Preview {
    NavigationView {
        UnitConverterPage()
    }
}
