//
//  PasswordGeneratorPage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct PasswordGeneratorPage: View {
    @State private var password: String = ""
    @State private var length: Double = 12
    @State private var includeUppercase = true
    @State private var includeLowercase = true
    @State private var includeNumbers = true
    @State private var includeSymbols = true
    @State private var showCopiedAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // 密碼顯示區
                VStack(spacing: 15) {
                    Text(NSLocalizedString("生成的密碼", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack {
                        Text(password.isEmpty ? NSLocalizedString("點擊生成密碼", comment: "") : password)
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .foregroundColor(password.isEmpty ? .gray : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        if !password.isEmpty {
                            Button(action: copyPassword) {
                                Image(systemName: "doc.on.doc")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // 密碼長度
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(NSLocalizedString("密碼長度", comment: ""))
                            .font(.headline)
                        Spacer()
                        Text("\(Int(length))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Slider(value: $length, in: 6...32, step: 1)
                        .tint(.blue)
                }
                .padding(.horizontal)

                // 選項
                VStack(spacing: 15) {
                    Text(NSLocalizedString("包含字元", comment: ""))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    PasswordOptionToggle(title: NSLocalizedString("大寫字母 (A-Z)", comment: ""), isOn: $includeUppercase)
                    PasswordOptionToggle(title: NSLocalizedString("小寫字母 (a-z)", comment: ""), isOn: $includeLowercase)
                    PasswordOptionToggle(title: NSLocalizedString("數字 (0-9)", comment: ""), isOn: $includeNumbers)
                    PasswordOptionToggle(title: NSLocalizedString("符號 (!@#$%)", comment: ""), isOn: $includeSymbols)
                }
                .padding(.horizontal)

                // 生成按鈕
                Button(action: generatePassword) {
                    HStack {
                        Image(systemName: "key.fill")
                        Text(NSLocalizedString("生成密碼", comment: ""))
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canGenerate ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(!canGenerate)
                .padding(.horizontal)

                // 密碼強度指示
                if !password.isEmpty {
                    PasswordStrengthView(password: password)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle(NSLocalizedString("Password Generator", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .alert(NSLocalizedString("已複製", comment: ""), isPresented: $showCopiedAlert) {
            Button(NSLocalizedString("確定", comment: ""), role: .cancel) {}
        } message: {
            Text(NSLocalizedString("密碼已複製到剪貼簿", comment: ""))
        }
    }

    private var canGenerate: Bool {
        return includeUppercase || includeLowercase || includeNumbers || includeSymbols
    }

    private func generatePassword() {
        var characters = ""

        if includeUppercase {
            characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if includeLowercase {
            characters += "abcdefghijklmnopqrstuvwxyz"
        }
        if includeNumbers {
            characters += "0123456789"
        }
        if includeSymbols {
            characters += "!@#$%^&*()_+-=[]{}|;:,.<>?"
        }

        password = String((0..<Int(length)).map { _ in characters.randomElement()! })
    }

    private func copyPassword() {
        UIPasteboard.general.string = password
        showCopiedAlert = true
    }
}

struct PasswordOptionToggle: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct PasswordStrengthView: View {
    let password: String

    var strength: (level: String, color: Color, progress: Double) {
        let length = password.count
        let hasUpper = password.contains(where: { $0.isUppercase })
        let hasLower = password.contains(where: { $0.isLowercase })
        let hasNumber = password.contains(where: { $0.isNumber })
        let hasSymbol = password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) })

        var score = 0
        if length >= 8 { score += 1 }
        if length >= 12 { score += 1 }
        if hasUpper { score += 1 }
        if hasLower { score += 1 }
        if hasNumber { score += 1 }
        if hasSymbol { score += 1 }

        switch score {
        case 0...2:
            return (NSLocalizedString("弱", comment: ""), .red, 0.33)
        case 3...4:
            return (NSLocalizedString("中等", comment: ""), .orange, 0.66)
        default:
            return (NSLocalizedString("強", comment: ""), .green, 1.0)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(NSLocalizedString("密碼強度", comment: ""))
                    .font(.headline)
                Spacer()
                Text(strength.level)
                    .font(.headline)
                    .foregroundColor(strength.color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(strength.color)
                        .frame(width: geometry.size.width * strength.progress, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        PasswordGeneratorPage()
    }
}
