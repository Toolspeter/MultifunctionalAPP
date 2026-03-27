//
//  TicTacToePage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct TicTacToePage: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer = "X"
    @State private var gameOver = false
    @State private var winner: String? = nil
    @State private var winningLine: [(Int, Int)] = []

    var body: some View {
        VStack(spacing: 30) {
            // 遊戲狀態
            VStack(spacing: 10) {
                if gameOver {
                    if let winner = winner {
                        Text(String(format: NSLocalizedString("🎉 %@ 獲勝！", comment: ""), winner))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                    } else {
                        Text(NSLocalizedString("平局！", comment: ""))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.orange)
                    }
                } else {
                    Text(String(format: NSLocalizedString("輪到 %@", comment: ""), currentPlayer))
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            .frame(height: 60)

            // 棋盤
            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { col in
                            TicTacToeCell(
                                value: board[row][col],
                                isWinning: winningLine.contains(where: { $0.0 == row && $0.1 == col })
                            )
                            .onTapGesture {
                                makeMove(row: row, col: col)
                            }
                        }
                    }
                }
            }
            .padding()

            // 重新開始按鈕
            Button(action: resetGame) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text(NSLocalizedString("重新開始", comment: ""))
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
        .navigationTitle(NSLocalizedString("Tic Tac Toe", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func makeMove(row: Int, col: Int) {
        guard !gameOver && board[row][col].isEmpty else { return }

        board[row][col] = currentPlayer
        checkWinner()

        if !gameOver {
            currentPlayer = currentPlayer == "X" ? "O" : "X"
        }
    }

    private func checkWinner() {
        // 檢查行
        for row in 0..<3 {
            if !board[row][0].isEmpty &&
               board[row][0] == board[row][1] &&
               board[row][1] == board[row][2] {
                winner = board[row][0]
                winningLine = [(row, 0), (row, 1), (row, 2)]
                gameOver = true
                return
            }
        }

        // 檢查列
        for col in 0..<3 {
            if !board[0][col].isEmpty &&
               board[0][col] == board[1][col] &&
               board[1][col] == board[2][col] {
                winner = board[0][col]
                winningLine = [(0, col), (1, col), (2, col)]
                gameOver = true
                return
            }
        }

        // 檢查對角線
        if !board[0][0].isEmpty &&
           board[0][0] == board[1][1] &&
           board[1][1] == board[2][2] {
            winner = board[0][0]
            winningLine = [(0, 0), (1, 1), (2, 2)]
            gameOver = true
            return
        }

        if !board[0][2].isEmpty &&
           board[0][2] == board[1][1] &&
           board[1][1] == board[2][0] {
            winner = board[0][2]
            winningLine = [(0, 2), (1, 1), (2, 0)]
            gameOver = true
            return
        }

        // 檢查平局
        if board.allSatisfy({ $0.allSatisfy { !$0.isEmpty } }) {
            gameOver = true
        }
    }

    private func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        gameOver = false
        winner = nil
        winningLine = []
    }
}

struct TicTacToeCell: View {
    let value: String
    let isWinning: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isWinning ? Color.green.opacity(0.3) : Color.blue.opacity(0.1))
                .frame(width: 100, height: 100)

            Text(value)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(value == "X" ? .blue : .red)
        }
    }
}

#Preview {
    NavigationView {
        TicTacToePage()
    }
}
