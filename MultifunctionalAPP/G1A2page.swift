//
//  1A2P.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct GuessRecord: Identifiable {
    let id = UUID()
    let guess: String
    let result: String
}

struct G1A2Bpage: View {

    @State private var targetNumber: [Int] = []
    @State private var currentGuess: String = ""
    @State private var guessHistory: [GuessRecord] = []
    @State private var gameStatus: String = NSLocalizedString("請輸入4位不重複的數字", comment: "")
    @State private var isGameWon: Bool = false
    @State private var attempts: Int = 0
    @FocusState private var isInputFocused: Bool
    @Environment(\.presentationMode) var presentationMode

    @Environment(\.colorScheme) var colorScheme

    var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.95, green: 0.94, blue: 0.92)
    }

    var cardBackground: Color {
        colorScheme == .dark ? Color(red: 0.2, green: 0.22, blue: 0.28) : Color(red: 1.0, green: 0.98, blue: 0.95)
    }

    var inputBackground: Color {
        colorScheme == .dark ? Color(red: 0.12, green: 0.14, blue: 0.18) : Color(red: 0.98, green: 0.96, blue: 0.93)
    }

    var accentColor: Color {
        colorScheme == .dark ? Color(red: 1.0, green: 0.75, blue: 0.4) : Color(red: 0.95, green: 0.6, blue: 0.2)
    }

    var body: some View {
        ZStack{
            backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 20){
                // 狀態顯示區
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(cardBackground)
                        .frame(height: 80)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                    VStack(spacing: 5) {
                        Text(gameStatus)
                            .font(.system(size: isGameWon ? 24 : 20, weight: .bold))
                            .foregroundColor(isGameWon ? .green : .primary)
                        if !isGameWon && attempts > 0 {
                            Text(String(format: NSLocalizedString("已猜測 %d 次", comment: ""), attempts))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }

                // 輸入區
                if !isGameWon {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(inputBackground)
                            .frame(height: 120)
                            .padding(.horizontal)
                            .shadow(color: accentColor.opacity(0.3), radius: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(accentColor.opacity(0.6), style: StrokeStyle(lineWidth: 3))
                                    .padding(.horizontal)
                            )

                        HStack(spacing: 15) {
                            TextField("", text: $currentGuess)
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(accentColor)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .focused($isInputFocused)
                                .onChange(of: currentGuess) { newValue in
                                    if newValue.count > 4 {
                                        currentGuess = String(newValue.prefix(4))
                                    }
                                }

                            if !currentGuess.isEmpty {
                                Button(action: {
                                    currentGuess = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(accentColor.opacity(0.6))
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }

                    // 猜測按鈕
                    Button(action: makeGuess) {
                        Text(NSLocalizedString("猜測", comment: ""))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: currentGuess.count == 4 ? [Color.blue, Color.blue.opacity(0.8)] : [Color.gray, Color.gray.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: currentGuess.count == 4 ? Color.blue.opacity(0.3) : Color.clear, radius: 5)
                            .padding(.horizontal)
                    }
                    .disabled(currentGuess.count != 4)
                }

                // 重新開始按鈕
                if isGameWon {
                    Button(action: startNewGame) {
                        Text(NSLocalizedString("再玩一次", comment: ""))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.green.opacity(0.3), radius: 5)
                            .padding(.horizontal)
                    }
                }

         // 歷史記錄
                if !guessHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(NSLocalizedString("猜測記錄", comment: ""))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(guessHistory.reversed()) { record in
                                    HStack {
                                        Text(record.guess)
                                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                        Spacer()
                                        Text(record.result)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(record.result == "4A0B" ? .green : .orange)
                                    }
                                    .padding()
                                    .background(cardBackground)
                                 .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 3)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(NSLocalizedString("1A2B", comment: ""))
                    .font(.system(size: 50, weight: .bold))
                    .padding(.vertical, 20)
            }
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text(NSLocalizedString("返回", comment: ""))
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: startNewGame){
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if targetNumber.isEmpty {
                startNewGame()
            }
        }
        .onTapGesture {
            isInputFocused = false
        }
    }

    // 生成不重複的4位數字
    private func generateTargetNumber() -> [Int] {
        var numbers = Array(0...9)
        numbers.shuffle()
        return Array(numbers.prefix(4))
    }

    // 開始新遊戲
    private func startNewGame() {
        targetNumber = generateTargetNumber()
        currentGuess = ""
        guessHistory = []
        gameStatus = NSLocalizedString("請輸入4位不重複的數字", comment: "")
        isGameWon = false
        attempts = 0
        isInputFocused = false
    }

    // 驗證輸入
    private func isValidGuess(_ guess: String) -> Bool {
        guard guess.count == 4 else { return false }
        guard guess.allSatisfy({ $0.isNumber }) else { return false }
        let digits = guess.map { Int(String($0))! }
        return Set(digits).count == 4 // 確保數字不重複
    }

    // 計算 A 和 B
    private func calculateResult(_ guess: String) -> (a: Int, b: Int) {
        let guessDigits = guess.map { Int(String($0))! }
        var aCount = 0
        var bCount = 0

        for (index, digit) in guessDigits.enumerated() {
            if digit == targetNumber[index] {
                aCount += 1
            } else if targetNumber.contains(digit) {
                bCount += 1
            }
        }

        return (aCount, bCount)
    }

    // 進行猜測
    private func makeGuess() {
        guard isValidGuess(currentGuess) else {
            gameStatus = NSLocalizedString("請輸入4位不重複的數字", comment: "")
            return
        }

        let result = calculateResult(currentGuess)
        let resultString = "\(result.a)A\(result.b)B"

        guessHistory.append(GuessRecord(guess: currentGuess, result: resultString))
        attempts += 1

        if result.a == 4 {
            gameStatus = NSLocalizedString("🎉 恭喜你猜對了！", comment: "")
            isGameWon = true
        } else {
            gameStatus = NSLocalizedString("繼續猜測...", comment: "")
        }

        currentGuess = ""
        isInputFocused = false
    }
}

#Preview {
    ContentView()
}

func setColor(red: Double, green: Double, blue: Double) -> Color {
    return Color(red:red/255,green:green/255,blue:blue/255)
}
