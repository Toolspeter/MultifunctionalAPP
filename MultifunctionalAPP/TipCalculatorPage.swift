//
//  TipCalculatorPage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct TipCalculatorPage: View {
    @State private var billAmount: String = ""
    @State private var tipPercentage: Double = 15
    @State private var numberOfPeople: Int = 1
    @FocusState private var isInputFocused: Bool

    var tipAmount: Double {
        guard let bill = Double(billAmount) else { return 0 }
        return bill * tipPercentage / 100
    }

    var totalAmount: Double {
        guard let bill = Double(billAmount) else { return 0 }
        return bill + tipAmount
    }

    var amountPerPerson: Double {
        return totalAmount / Double(numberOfPeople)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // 帳單金額輸入
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("帳單金額", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack {
                        Text("$")
                            .font(.title)
                            .foregroundColor(.gray)

                        TextField("0.00", text: $billAmount)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                            .font(.system(size: 36, weight: .bold))

                        if !billAmount.isEmpty {
                            Button(action: { billAmount = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // 小費百分比選擇
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(NSLocalizedString("小費比例", comment: ""))
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(tipPercentage))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Slider(value: $tipPercentage, in: 0...30, step: 1)
                        .tint(.blue)

                    HStack {
                        ForEach([10, 15, 18, 20], id: \.self) { percentage in
                            Button(action: {
                                tipPercentage = Double(percentage)
                            }) {
                                Text("\(percentage)%")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(tipPercentage == Double(percentage) ? .white : .blue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(tipPercentage == Double(percentage) ? Color.blue : Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // 人數選擇
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("分攤人數", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack(spacing: 15) {
                        Button(action: {
                            if numberOfPeople > 1 {
                                numberOfPeople -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .foregroundColor(numberOfPeople > 1 ? .blue : .gray)
                        }
                        .disabled(numberOfPeople <= 1)

                        Text("\(numberOfPeople)")
                            .font(.system(size: 32, weight: .bold))
                            .frame(minWidth: 60)

                        Button(action: {
                            numberOfPeople += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // 結果顯示
                VStack(spacing: 15) {
                    ResultRow(title: NSLocalizedString("小費金額", comment: ""), amount: tipAmount, color: .orange)
                    ResultRow(title: NSLocalizedString("總金額", comment: ""), amount: totalAmount, color: .blue)

                    Divider()
                        .padding(.vertical, 5)

                    VStack(spacing: 8) {
                        Text(NSLocalizedString("每人應付", comment: ""))
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("$\(amountPerPerson, specifier: "%.2f")")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: .primary.opacity(0.1), radius: 5)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle(NSLocalizedString("Tip Calculator", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            isInputFocused = false
        }
    }
}

struct ResultRow: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            Spacer()

            Text("$\(amount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        TipCalculatorPage()
    }
}
