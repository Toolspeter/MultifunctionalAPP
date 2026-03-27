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

    var body: some View {
        ZStack{
            setColor(red: 230, green: 213, blue: 183)
            VStack(spacing: 20){
                // 狀態顯示區
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(setColor(red: 244, green: 233, blue: 215))
                        .frame(height: 80)
                        .padding(.horizontal)
                        .shadow(radius: 5)
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
                            .fill(setColor(red: 29, green: 37, blue: 42))
                            .frame(height: 120)
                            .padding(.horizontal)
                            .shadow(color: setColor(red: 34, green: 53, blue: 74), radius: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setColor(red: 34, green: 53, blue: 74), style: StrokeStyle(lineWidth: 10))
                                    .padding(.horizontal)
                            )

                        HStack(spacing: 15) {
                            TextField("", text: $currentGuess)
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(setColor(red: 239, green: 189, blue: 99))
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
                                        .foregroundColor(setColor(red: 239, green: 189, blue: 99).opacity(0.6))
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
                            .background(currentGuess.count == 4 ? Color.blue : Color.gray)
                            .cornerRadius(12)
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
                            .background(Color.green)
                            .cornerRadius(12)
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
                                    .background(Color.white.opacity(0.8))
                                 .cornerRadius(10)
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
        .toolbarBackground(setColor(red: 46, green: 66, blue: 85), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(NSLocalizedString("1A2B", comment: ""))
                    .foregroundColor(setColor(red: 245, green: 235, blue: 215))
                    .font(.system(size: 50, weight: .bold))
                    .padding(.vertical, 20)
            }
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text(NSLocalizedString("返回", comment: ""))
                        .foregroundColor(setColor(red: 245, green: 235, blue: 215))
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: startNewGame){
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(setColor(red: 245, green: 235, blue: 215))
                }
            }
        }
        .navigationBarBackButtonHidden()
   .toolbarBackground(.visible, for: .navigationBar)
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
